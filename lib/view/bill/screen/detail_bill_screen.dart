import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';

class DetailTagihanScreen extends StatelessWidget {
  const DetailTagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.primary300,
      appBar: AppBar(
        title: Text('Detail Tagihan',
            style: TextStylesConstant.nunitoHeading5
                .copyWith(color: ColorsConstant.white)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorsConstant.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsConstant.primary300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified, size: 50, color: Colors.blue),
                    const SizedBox(height: 8),
                    const Text(
                      'Tagihanmu berhasil dicetak',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '3/02/2024',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Divider(height: 32),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DARI',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text('Educode Purwokerto'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KEPADA',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text('Kartika Dewi Faith'),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rincian Tagihan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: List.generate(4, (index) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Coding Construct'),
                                  Text('03/05/25'),
                                  Text('Rp75.000'),
                                ],
                              ),
                            );
                          }),
                        ),
                        const Divider(height: 32),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Rp222.000',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Note:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tidak ada catatan untuk tagihan ini',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
