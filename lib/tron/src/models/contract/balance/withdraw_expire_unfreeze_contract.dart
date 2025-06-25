import 'package:on_chain/tron/src/address/tron_address.dart';
import 'package:on_chain/tron/src/models/contract/base_contract/base.dart';
import 'package:on_chain/tron/src/protbuf/decoder.dart';
import 'package:on_chain/utils/utils/utils.dart';

/// Withdraw unfrozen balance in Stake2.0, the user can
/// call this API to get back their funds after executing /wallet/unfreezebalancev2
/// transaction and waiting N days, N is a network parameter
class WithdrawExpireUnfreezeContract extends TronBaseContract {
  /// Create a new [WithdrawExpireUnfreezeContract] instance by parsing a JSON map.
  factory WithdrawExpireUnfreezeContract.fromJson(Map<String, dynamic> json) {
    return WithdrawExpireUnfreezeContract(
      ownerAddress: OnChainUtils.parseTronAddress(
          value: json['owner_address'], name: 'owner_address'),
    );
  }
  factory WithdrawExpireUnfreezeContract.deserialize(List<int> bytes) {
    final decode = TronProtocolBufferImpl.decode(bytes);
    return WithdrawExpireUnfreezeContract(
        ownerAddress: TronAddress.fromBytes(decode.getField(1)));
  }

  /// Create a new [WithdrawExpireUnfreezeContract] instance with specified parameters.
  WithdrawExpireUnfreezeContract({required this.ownerAddress});

  /// Account address
  @override
  final TronAddress ownerAddress;

  @override
  List<int> get fieldIds => [1];

  @override
  List get values => [ownerAddress];

  /// Convert the [WithdrawExpireUnfreezeContract] object to a JSON representation.
  @override
  Map<String, dynamic> toJson({bool visible = true}) {
    return {'owner_address': ownerAddress.toAddress(visible)};
  }

  /// Convert the [WithdrawExpireUnfreezeContract] object to its string representation.
  @override
  String toString() {
    return 'WithdrawExpireUnfreezeContract{$toJson()}';
  }

  @override
  TransactionContractType get contractType =>
      TransactionContractType.withdrawExpireUnfreezeContract;
}
