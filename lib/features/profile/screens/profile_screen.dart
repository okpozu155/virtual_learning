import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Dynamic Adaptive Palette Architecture
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color deepCharcoal = isDark 
        ? const Color(0xFFF8FAFC) // Crisp white-silver for dark mode
        : const Color(0xFF0F172A); // Midnight charcoal for light mode
        
    final Color slateText = isDark 
        ? const Color(0xFF94A3B8) 
        : const Color(0xFF64748B);

    const Color slatePrimary = Color(0xFF3B5866);
    const Color cardBorder = Color(0xFFE2E8F0);

    //Connect to the App Theme Pipeline
    final AppThemeNotifier themeNotifier = AppThemeScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        children: [
          //Header Avatar Section
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: slatePrimary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_rounded, size: 54, color: slatePrimary),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: slatePrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Researcher Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: deepCharcoal),
                ),
                const SizedBox(height: 4),
                Text(
                  "student@virtuallearn.edu",
                  style: TextStyle(fontSize: 14, color: slateText, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          // Metric Achievement Row (Adapts to card theme background)
          Row(
            children: [
              _buildStatCard(context, "Quizzes", "0", Icons.quiz_rounded, const Color(0xFF8B5CF6), cardBorder, deepCharcoal, slateText),
              const SizedBox(width: 16),
              _buildStatCard(context, "Slides", "0", Icons.biotech_rounded, const Color(0xFF10B981), cardBorder, deepCharcoal, slateText),
              const SizedBox(width: 16),
              _buildStatCard(context, "Hours", "0.0", Icons.timer_rounded, const Color(0xFFF59E0B), cardBorder, deepCharcoal, slateText),
            ],
          ),

          const SizedBox(height: 32),

          //Settings Menu Matrix
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.transparent : cardBorder),
            ),
            child: Column(
              children: [
                _buildMenuRow(Icons.person_outline_rounded, "Account Settings", slatePrimary, deepCharcoal),
                _buildDivider(cardBorder, isDark),
                _buildMenuRow(Icons.notifications_none_rounded, "Notifications", slatePrimary, deepCharcoal),
                _buildDivider(cardBorder, isDark),
                _buildMenuRow(Icons.security_rounded, "Security & Privacy", slatePrimary, deepCharcoal),
                _buildDivider(cardBorder, isDark),
                
                // Premium Styled Dark Mode Dynamic Toggle Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.dark_mode_outlined, color: slatePrimary, size: 22),
                          const SizedBox(width: 16),
                          Text(
                            "Dark Mode", 
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: deepCharcoal)
                          ),
                        ],
                      ),
                      
                      Switch.adaptive(
                        value: themeNotifier.isDarkMode,
                        activeThumbColor: slatePrimary,
                        onChanged: (val) {
                          themeNotifier.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Minimalist Editorial Logout Action
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: isDark ? const Color(0xFFEF4444).withValues(alpha: 0.4) : const Color(0xFFFCA5A5), width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {},
              child: const Text("Log Out", style: TextStyle(color: Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  //Modular Helper UI Widgets
  Widget _buildStatCard(BuildContext context, String label, String val, IconData icon, Color color, Color border, Color textCol, Color labelCol) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: isDark ? Colors.transparent : border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textCol)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelCol)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title, Color iconCol, Color textCol) {
    return ListTile(
      leading: Icon(icon, color: iconCol, size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textCol)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
      onTap: () {},
    );
  }

  Widget _buildDivider(Color border, bool isDark) {
    return Divider(
      height: 1, 
      thickness: 1, 
      indent: 20, 
      endIndent: 20, 
      color: isDark ? Colors.white10 : border.withValues(alpha: 0.6),
    );
  }
}