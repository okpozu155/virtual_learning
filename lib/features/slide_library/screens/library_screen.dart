import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Design System Colors
    const Color deepCharcoal = Color(0xFF0F172A);
    const Color slateText = Color(0xFF64748B);
    const Color premiumBg = Color(0xFFF8FAFC);
    const Color cardBorder = Color(0xFFE2E8F0);

    // Slide Data Matrix matching your teammate's content precisely
    final List<Map<String, dynamic>> slides = [
      {
        "title": "Animal Cell",
        "category": "Cytology • 400x Mag",
        "progress": 0.0,
        "status": "Not Started",
        "icon": Icons.blur_circular_rounded,
        "accent": const Color(0xFF3B82F6), // Professional Blue
      },
      {
        "title": "Blood Smear",
        "category": "Hematology • Wright's Stain",
        "progress": 0.0,
        "status": "Not Started",
        "icon": Icons.bloodtype_rounded,
        "accent": const Color(0xFFEF4444), // Crimson Red
      },
      {
        "title": "Cell Division",
        "category": "Genetics • Mitosis Phase",
        "progress": 0.0,
        "status": "Not Started",
        "icon": Icons.splitscreen_rounded, // 🎯 Fixed invalid character and icon name
        "accent": const Color(0xFF8B5CF6), // Royal Purple
      },
      {
        "title": "Human Embryo",
        "category": "Embryology • Developmental stage",
        "progress": 0.0,
        "status": "Not Started",
        "icon": Icons.egg_rounded, // 🎯 Fixed non-existent icon name
        "accent": const Color(0xFFF59E0B), // Deep Amber
      },
    ];

    return Scaffold(
      backgroundColor: premiumBg,
      
      //Sleek Minimalist AppBar
      appBar: AppBar(
        backgroundColor: premiumBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: deepCharcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Slide Library",
          style: TextStyle(
            color: deepCharcoal,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Clean, Shadowless Search Input Matrix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder, width: 1.5),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_rounded, color: slateText, size: 22),
                    hintText: "Search slides...",
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 15, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Dynamic, Scrollable Slide List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  final Color accentColor = slide['accent'];
                  final IconData slideIcon = slide['icon'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cardBorder, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: deepCharcoal.withValues(alpha: 0.015), // 🎯 Modernized syntax
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Premium Specimen Thumbnail Placeholder Container
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.06), // 🎯 Modernized syntax
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: accentColor.withValues(alpha: 0.12), width: 1), // 🎯 Modernized syntax
                          ),
                          child: Icon(
                            slideIcon,
                            color: accentColor,
                            size: 36,
                          ),
                        ),
                        
                        const SizedBox(width: 16),

                        // Structured Information Block
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide['title'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: deepCharcoal,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                slide['category'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: slateText,
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              // Unified Progress Indicator Architecture
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: slide['progress'],
                                        minHeight: 6,
                                        backgroundColor: const Color(0xFFF1F5F9),
                                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "${(slide['progress'] * 100).toInt()}%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // 🚀 Minimalist Styled Status Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            slide['status'],
                            style: const TextStyle(
                              color: slateText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}