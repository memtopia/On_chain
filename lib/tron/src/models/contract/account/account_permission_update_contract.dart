import 'package:on_chain/tron/src/address/tron_address.dart';
import 'package:on_chain/tron/src/models/contract/base_contract/base.dart';
import 'package:on_chain/tron/src/models/contract/account/permission.dart';
import 'package:on_chain/tron/src/protbuf/decoder.dart';
import 'package:on_chain/utils/utils/utils.dart';

/// Update the account's permission.
class AccountPermissionUpdateContract extends TronBaseContract {
  /// Create a new [AccountPermissionUpdateContract] instance by parsing a JSON map.
  factory AccountPermissionUpdateContract.fromJson(Map<String, dynamic> json) {
    return AccountPermissionUpdateContract(
        ownerAddress: OnChainUtils.parseTronAddress(
            value: json['owner_address'], name: 'owner_address'),
        owner: Permission.fromJson(OnChainUtils.parseMap(
            value: json['owner'], name: 'owner', throwOnNull: true)!),
        witness:
            OnChainUtils.parseMap(value: json['witness'], name: 'witness') ==
                    null
                ? null
                : Permission.fromJson(json['witness']),
        actives: OnChainUtils.parseList(value: json['actives'], name: 'actives')
                ?.map((e) => Permission.fromJson(e))
                .toList() ??
            <Permission>[]);
  }

  factory AccountPermissionUpdateContract.deserialize(List<int> bytes) {
    final decode = TronProtocolBufferImpl.decode(bytes);
    return AccountPermissionUpdateContract(
        ownerAddress: TronAddress.fromBytes(decode.getField(1)),
        owner: Permission.deserialize(decode.getField(2)),
        witness: decode
            .getResult(3)
            ?.castTo<Permission, List<int>>((e) => Permission.deserialize(e)),
        actives: decode
            .getFields<List<int>>(4)
            .map((e) => Permission.deserialize(e))
            .toList());
  }

  /// Create a new [AccountPermissionUpdateContract] instance with specified parameters.
  AccountPermissionUpdateContract(
      {required this.ownerAddress,
      required this.owner,
      this.witness,
      required List<Permission> actives})
      : actives = List<Permission>.unmodifiable(actives);

  /// account address
  @override
  final TronAddress ownerAddress;

  /// The owner permission of the account.
  final Permission owner;

  /// Account witness permissions
  final Permission? witness;

  /// List of active permissions for the account
  final List<Permission> actives;

  /// Create a new [AccountPermissionUpdateContract] instance by copying the existing one
  /// and replacing specified fields with new values.
  AccountPermissionUpdateContract copyWith({
    TronAddress? ownerAddress,
    Permission? owner,
    Permission? witness,
    List<Permission>? actives,
  }) {
    return AccountPermissionUpdateContract(
      ownerAddress: ownerAddress ?? this.ownerAddress,
      owner: owner ?? this.owner,
      witness: witness ?? this.witness,
      actives: actives ?? this.actives,
    );
  }

  @override

  /// Convert the [AccountPermissionUpdateContract] object to a JSON representation.
  Map<String, dynamic> toJson({bool visible = true}) {
    return {
      'owner_address': ownerAddress.toAddress(visible),
      'actives': actives.map((e) => e.toJson(visible: visible)).toList(),
      'owner': owner.toJson(),
      'witness': witness?.toJson(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<int> get fieldIds => [1, 2, 3, 4];

  @override
  List get values => [ownerAddress, owner, witness, actives];

  /// Convert the [AccountPermissionUpdateContract] object to its string representation.
  @override
  String toString() {
    return 'AccountPermissionUpdateContract{${toJson()}}';
  }

  @override
  TransactionContractType get contractType =>
      TransactionContractType.accountPermissionUpdateContract;
}
