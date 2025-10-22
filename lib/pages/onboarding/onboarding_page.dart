import 'package:calm_notes_app/pages/Terms/terms.dart';
import 'package:calm_notes_app/pages/editor/editor.dart';
import 'package:calm_notes_app/pages/home/home.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    const totalPages = 3;
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: _currentPage == 1 || _currentPage == 2
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        TermsPage(onNext: _nextPage),
        HomePage(onNext: _nextPage),
        const EditorPage(),
        
        
      ],
    );
  }
}
