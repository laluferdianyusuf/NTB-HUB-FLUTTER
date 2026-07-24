import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/enums/app_enums.dart';
import '../../../../../models/wallet_model.dart';
import '../../../../../repository/account_repository.dart';
import '../../../../../repository/ledger_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(client: ref.watch(dioClientProvider)),
);

final ledgerRepositoryProvider = Provider<LedgerRepository>(
  (ref) => LedgerRepository(client: ref.watch(dioClientProvider)),
);

final walletBalanceProvider =
    FutureProvider<result.Result<WalletSnapshot>>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth == null || !auth.isAuthenticated) {
    return const result.Error(UnknownFailure('Belum login'));
  }

  final accountResult = await ref.read(accountRepositoryProvider).ensureAccount(
        EnsureAccountPayload(
          type: AccountType.user,
          userId: auth.userId,
        ),
      );

  switch (accountResult) {
    case result.Success(:final data):
      final account = data;
      if (account.id.isEmpty) {
        return const result.Error(UnknownFailure('Akun dompet tidak ditemukan'));
      }

      final balanceResult = await ref
          .read(ledgerRepositoryProvider)
          .getAccountBalance(account.id);

      return switch (balanceResult) {
        result.Success(:final data) => result.Success(
          WalletSnapshot(
            account: account,
            balance: data.balance,
            updatedAt: data.updatedAt ?? account.updatedAt,
          ),
        ),
        result.Error(:final failure) => result.Error(failure),
      };
    case result.Error(:final failure):
      return result.Error(failure);
  }
});
