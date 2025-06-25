import 'package:on_chain/tron/src/models/contract/base_contract/base.dart';
import 'package:on_chain/tron/src/models/contract/transaction/any.dart';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain/tron/src/protbuf/decoder.dart';
import 'package:on_chain/utils/utils.dart';

class TransactionContract extends TronProtocolBufferImpl {
  /// Create a new [TransactionContract] instance by parsing a JSON map.
  factory TransactionContract.fromJson(Map<String, dynamic> json) {
    final type = TransactionContractType.findByName(
        OnChainUtils.parseString(value: json['type'], name: 'type'));
    final any = Any.fromJson(OnChainUtils.parseMap(
        value: json['parameter'], name: 'parameter', throwOnNull: true)!);
    final int? permissionId = OnChainUtils.parseInt(
        value: json['permission_id'] ?? json['Permission_id'],
        name: 'permission_id');

    return TransactionContract(
      type: type,
      parameter: any,
      permissionId: permissionId,
      provider:
          OnChainUtils.parseBytes(value: json['provider'], name: 'provider'),
      contractName: OnChainUtils.parseBytes(
          value: json['contract_name'], name: 'contract_name'),
    );
  }

  /// Create a new [TransactionContract] instance with specified parameters.
  TransactionContract(
      {required this.type,
      required this.parameter,
      List<int>? provider,
      List<int>? contractName,
      this.permissionId})
      : provider = BytesUtils.tryToBytes(provider, unmodifiable: true),
        contractName = BytesUtils.tryToBytes(contractName, unmodifiable: true);

  factory TransactionContract.deserialize(List<int> bytes) {
    final decode = TronProtocolBufferImpl.decode(bytes);
    return TransactionContract(
        type: TransactionContractType.findByValue(decode.getField(1)) ??
            TransactionContractType.accountCreateContract,
        parameter: Any.deserialize(decode.getField(2)),
        provider: decode.getField(3),
        contractName: decode.getField(4),
        permissionId: decode.getField(5));
  }
  final TransactionContractType type;
  final Any parameter;
  final List<int>? provider;
  final List<int>? contractName;
  final int? permissionId;

  /// Convert the [TransactionContract] object to a JSON representation.
  @override
  Map<String, dynamic> toJson({bool visible = true}) {
    return {
      'type': type.name,
      'parameter': parameter.toJson(visible: visible),
      'contract_name': StringUtils.tryDecode(contractName),
      'provider': StringUtils.tryDecode(provider),
      'Permission_id': permissionId
    }..removeWhere((key, value) => value == null);
  }

  @override
  List<int> get fieldIds => [1, 2, 3, 4, 5];

  @override
  List get values => [
        type.value == 0 ? null : type,
        parameter,
        provider,
        contractName,
        permissionId
      ];

  /// Convert the [TransactionContract] object to its string representation.
  @override
  String toString() {
    return 'TransactionContract{${toJson()}}';
  }
}
