import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../widget/commonAppBar.dart';

import '../viewModel/cmsPro.dart';

class CMSContentScreen extends StatefulWidget {
  final String title;
  final CMSContentType type;

  const CMSContentScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<CMSContentScreen> createState() => _CMSContentScreenState();
}

enum CMSContentType {
  privacy,
  terms,
  refund,
}

class _CMSContentScreenState extends State<CMSContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CMSProvider>(context, listen: false);
      _loadData(provider);
    });
  }

  void _loadData(CMSProvider provider) {
    switch (widget.type) {
      case CMSContentType.privacy:
        provider.getPrivacyPolicyApi(context: context);
        break;
      case CMSContentType.terms:
        provider.getTermsConditionsApi(context: context);
        break;
      case CMSContentType.refund:
        provider.getRefundPolicyApi(context: context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.title,
        isBack: false,
      ),
      body: Consumer<CMSProvider>(
        builder: (context, provider, child) {
          bool isLoading = provider.isLoading;

          dynamic model;
          String? content;

          switch (widget.type) {
            case CMSContentType.privacy:
              model = provider.privacyPolicyModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.privacyPolicy
                  : null;
              break;
            case CMSContentType.terms:
              model = provider.termConditionsModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.termCondition
                  : null;
              break;
            case CMSContentType.refund:
              model = provider.refundPrivacyPolicyModel;
              content = model?.data?.isNotEmpty == true
                  ? model.data!.first.privacyPolicy
                  : null;
              break;
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (model == null || model.status != true || content == null || content.isEmpty) {
            content = _getDefaultContent();
          }

          // if (model == null || model.status != true) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const Icon(Icons.error_outline, size: 60, color: Colors.red),
          //         const SizedBox(height: 16),
          //         const Text(
          //           "Failed to load content",
          //           style: TextStyle(fontSize: 18, color: Colors.grey),
          //         ),
          //         const SizedBox(height: 16),
          //         ElevatedButton(
          //           onPressed: () => _loadData(provider),
          //           child: const Text("Retry"),
          //         ),
          //       ],
          //     ),
          //   );
          // }

          if (content == null || content.isEmpty) {
            return const Center(
              child: Text(
                "No content available",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: content,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: LineHeight(1.6),
                  color: Colors.black87,
                ),
                "h1": Style(fontSize: FontSize(24), fontWeight: FontWeight.bold),
                "h2": Style(fontSize: FontSize(20), fontWeight: FontWeight.w600),
                "p": Style(margin: Margins.symmetric(vertical: 8)),
                "ul": Style(margin: Margins.symmetric(vertical: 8)),
                "li": Style(margin: Margins.only(bottom: 6)),
                "a": Style(color: Colors.blue),
              },
              onLinkTap: (url, _, __) {
                // Optional: open link in browser
                // launchUrl(Uri.parse(url ?? ''));
                debugPrint("Link tapped: $url");
              },
            ),
          );
        },
      ),
    );
  }
  String _getDefaultContent() {
    switch (widget.type) {
      case CMSContentType.privacy:
        return """
      <h2>Privacy Policy - Driver Maan</h2>
      <p>Your privacy is important to us. We collect driver and vehicle details only for service purposes.</p>
      <ul>
        <li>We do not share your personal data with third parties.</li>
        <li>Location data is used for ride tracking and safety.</li>
        <li>All payments are securely processed.</li>
      </ul>
      """;

      case CMSContentType.terms:
        return """
      <h2>Terms & Conditions - Driver Maan</h2>
      <p>By using this app, drivers agree to follow these rules:</p>
      <ul>
        <li>Maintain valid driving license and vehicle documents.</li>
        <li>Ensure vehicle cleanliness and safety.</li>
        <li>Follow traffic rules strictly.</li>
        <li>Misuse of app may lead to account suspension.</li>
      </ul>
      """;

      case CMSContentType.refund:
        return """
      <h2>Refund Policy - Driver Maan</h2>
      <p>Refunds are processed based on ride cancellation conditions.</p>
      <ul>
        <li>Incorrect charges can be reported within 24 hours.</li>
        <li>Refunds will be credited within 5-7 working days.</li>
        <li>Driver penalties may apply in case of service issues.</li>
      </ul>
      """;
    }
  }
}

