import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  static const routeName = 'PrivacyPolicy';
  const PrivacyPolicy({super.key});
  Widget buildText(String abouttext, String detailtext) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 6.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$abouttext: ',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: detailtext,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Privacy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.2, vertical: 6.0),
              child: Text(
                'We understand the importance of privacy. We provide an online chat platform to communicate with people, free from data collection.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildText(
              '1) General Data Protection Regulation (GDPR)',
              'This chat app does not collect any personal data or usage details, therefore it does not require a Data Protection Officer (DPO).',
            ),
            buildText(
              '2) Privacy of Messages',
              'This chat app uses end-to-end encryption (E2EE) for secure and private messaging. Only the intended recipient can read the messages. We do not store any message content.',
            ),
            buildText(
              '3) Accounts',
              'The chat app requires an account to be used. We only store a unique identifier, the account username, and the associated hashed password for security purposes.',
            ),
            buildText(
              '4) Data Security',
              'This chat app has implemented various security measures to protect your data from unauthorized access and improper use.',
            ),
            buildText(
              '5) Cookies',
              'We do not use cookies or other similar technologies to collect or store your personal data.',
            ),
            buildText(
              '6) Data Minimization',
              'This chat app focuses on privacy and security, which is why we only collect the minimum data necessary to provide our service.',
            ),
            buildText(
              '7) Children\'s Privacy',
              'Our service is not intended for use by children under the age of 13. We do not knowingly collect personal information from children.',
            ),
            buildText(
              '8) Changes to this Privacy Policy',
              ' We may update our privacy policy from time to time. Thus, it is recommended to review this page periodically for any changes.',
            ),
            buildText(
              '9) Contact Information',
              ' If you have any questions or concerns about our privacy policy, please feel free to contact us at Nexsocial@nex.uk.',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.2, vertical: 6.0),
              child: Text(
                'We hope this information addresses your concerns. Please note that this chat app does not collect or store any personal information. Your privacy is our top priority.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
