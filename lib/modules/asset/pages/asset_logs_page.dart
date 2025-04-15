import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/text/text.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/utils/date_util.dart';
import '../../../data/models/asset_model.dart';
import '../controllers/asset_controller.dart';

class AssetLogsPage extends StatefulWidget {
  const AssetLogsPage({super.key});

  @override
  State<AssetLogsPage> createState() => _AssetLogsPageState();
}

class _AssetLogsPageState extends State<AssetLogsPage> {
  AssetController controller = Get.find();

  AssetModel asset = Get.arguments["asset"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.google(text: "Asset Logs", color: AppColor.white),
        backgroundColor: AppColor.blue0A1A48,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: AppText.google(text: UtilDate.formatDateTime(asset.logs[index].createdAt)),
            subtitle: AppText.google(
              text: asset.logs[index].log,
            ),
            trailing: AppText.google(text: UtilDate.timeAgo(asset.logs[index].createdAt)),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: AppColor.grey,
        ),
        itemCount: asset.logs.length,
      ),
    );
  }
}
