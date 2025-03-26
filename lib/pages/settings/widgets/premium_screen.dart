import 'package:flutter/material.dart';
class PremiumScreen extends StatelessWidget {
  final BuildContext ctx;
  const PremiumScreen({required this.ctx, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              IconButton(onPressed: (){
                Navigator.pop(ctx);
              }, icon: const Icon(Icons.close_rounded)),
              const Center(
                child: Text(
                  "Go Premium 🏆",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(child: Text("Unlock all features", style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPlanOption("Monthly", "\$9.99", "/month", false)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPlanOption("Yearly", "\$59.99", "\$4.99/month", true)),
                ],
              ),
              const SizedBox(height: 16),
              _buildFeaturesList(),
              const SizedBox(height: 16),
              _buildTestimonial(),
              const SizedBox(height: 16),
              _buildSubscribeButton(),
            ],
          ),
        ),

    );
  }

  Widget _buildPlanOption(String title, String price, String subtitle, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: isHighlighted ? Colors.blue : Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: isHighlighted ? const Color(0xff2563EB).withOpacity(0.1) : Colors.white,
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          if (isHighlighted)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xff2563EB), borderRadius: BorderRadius.circular(8)),
              child: const Text("Save 50%", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      "Unlimited Habits",
      "Detailed Analytics",
      "Custom Categories",
      "Priority Support",
      "Data Export",
      "Dark Mode",
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("What you'll get", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Text(feature),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
            ],
          ),
          SizedBox(height: 8),
          Text("'Best investment in my personal growth!'", style: TextStyle(fontStyle: FontStyle.italic)),
          SizedBox(height: 4),
          Text("Pankaj", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffA58506),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.pop(ctx);
        },
        child: const Text("Start Premium Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
