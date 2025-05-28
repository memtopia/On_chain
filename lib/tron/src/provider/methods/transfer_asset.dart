import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain/tron/src/address/tron_address.dart';
import 'package:on_chain/tron/src/models/contract/assets_issue_contract/asset.dart';
import 'package:on_chain/tron/src/models/contract/transaction/transaction.dart';
import 'package:on_chain/tron/src/provider/core/request.dart';
import 'package:on_chain/tron/src/provider/methods/request_methods.dart';

/// Transfer TRC10 token.
/// [developers.tron.network](https://developers.tron.network/reference/transferasset).
class TronRequestTransferAsset
    extends TronRequest<Transaction, Map<String, dynamic>> {
  factory TronRequestTransferAsset.fromJson(TransferAssetContract contract,
      {bool visible = true, int? permissionId, String? extraData}) {
    return TronRequestTransferAsset(
      ownerAddress: contract.ownerAddress,
      toAddress: contract.toAddress,
      assetName: StringUtils.decode(contract.assetName),
      amount: contract.amount,
      permissionId: permissionId,
      visible: visible,
      extraData: extraData,
    );
  }

  TronRequestTransferAsset(
      {required this.ownerAddress,
      required this.toAddress,
      required this.assetName,
      required this.amount,
      this.permissionId,
      this.extraData,
      this.visible = true});

  /// Owner address
  final TronAddress ownerAddress;

  /// receiving address
  final TronAddress toAddress;

  /// Token id
  final String? assetName;

  /// amount
  final BigInt amount;

  /// for multi-signature use
  final int? permissionId;
  @override
  final bool visible;

  /// totes on the transaction
  final String? extraData;

  /// wallet/transferasset
  @override
  TronHTTPMethods get method => TronHTTPMethods.transferasset;

  @override
  Map<String, dynamic> toJson() {
    return {
      'owner_address': ownerAddress.toAddress(visible),
      'to_address': toAddress.toAddress(visible),
      'asset_name': assetName,
      'amount': amount,
      'Permission_id': permissionId,
      'visible': visible,
      'extra_data': extraData
    };
  }

  @override
  String toString() {
    return 'TronRequestTransferAsset{${toJson()}}';
  }

  @override
  Transaction onResonse(result) {
    return Transaction.fromJson(result);
  }
}
