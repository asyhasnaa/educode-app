import 'package:educode/utils/constants/icons..dart';

class OnboardingModel {
  String image;
  String title;
  String description;

  OnboardingModel(
      {required this.image, required this.title, required this.description});
}

List<OnboardingModel> contents = [
  OnboardingModel(
      image: IconsConstant.onboarding1,
      title: 'Siapkan Masa Depan dengan Coding',
      description:
          'Belajar coding dari dasar dengan metode yang dirancang khusus untuk anak-anak. Ciptakan solusi kreatif sambil bersenang-senang!'),
  OnboardingModel(
      image: IconsConstant.onboarding2,
      title: 'Mengerjakan Projek Seru',
      description:
          'Dari animasi hingga aplikasi, eksplorasi keterampilan coding dengan proyek-proyek yang seru dan edukatif.'),
  OnboardingModel(
      image: IconsConstant.onboarding3,
      title: 'Belajar dari Mentor Terbaik',
      description:
          'Dapatkan bimbingan langsung \ndari para ahli yang siap membantu anak-anak berkembang dalam dunia coding.'),
];
