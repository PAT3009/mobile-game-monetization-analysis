# Mobile Game Monetization Analysis

**End-to-End Data Analytics Project** | SQL Server + Power BI

## 📋 Project Overview

This project analyzes mobile game monetization and player spending behavior to uncover key revenue drivers, understand player engagement patterns, and identify opportunities to improve monetization strategies.

The analysis follows an end-to-end data analytics workflow:

- Data Quality Assessment & Preparation (SQL Server)
- Business Data Analysis (SQL Server)
- Interactive Data Visualization (Power BI)
- Business Insights & Recommendations

**Core Business Question:**

"How can mobile game companies leverage player data to understand spending behavior, identify high-value players, and optimize monetization strategies?"

## 🎯 Business Problem

Mobile game companies need to understand how players interact with games and how their behaviors relate to in-app purchase spending. However, total revenue alone may not reveal which player segments contribute the most value or where monetization opportunities exist.

This project investigates differences in spending across player segments, engagement levels, devices, game genres, age groups, and payment methods. The goal is to identify meaningful patterns that can support player retention, engagement initiatives, and data-driven monetization decisions.

## 📊 Project Scope

1. **Data Quality Assessment (SQL Server)** – Examine dataset structure, validate player identifiers, identify missing values, and investigate potential data inconsistencies.
2. **Revenue & Player Segmentation Analysis (SQL Server)** – Analyze revenue contribution across Whale, Dolphin, and Minnow spending segments.
3. **Player Engagement Analysis (SQL Server)** – Compare recorded spending across low-, medium-, and high-engagement players.
4. **Monetization Performance Analysis (SQL Server)** – Investigate spending patterns by device, game genre, age group, and payment method.
5. **Data Visualization (Power BI)** – Build an interactive dashboard to explore revenue performance and player behavior.
6. **Insights & Recommendations** – Translate analytical findings into practical opportunities for player retention and monetization improvement.

## 📁 Dataset Summary

- **Rows:** 3,024
- **Unit of Analysis:** One record per player
- **Key Features:** UserID, Age, Gender, Country, Device, GameGenre, SessionCount, AverageSessionLength, SpendingSegment, InAppPurchaseAmount, FirstPurchaseDaysAfterInstall, PaymentMethod, LastPurchaseDate
- **Data Quality:** Missing values were identified in demographic and purchase-related fields. The Age variable appeared to be stored at ten times its expected value and was normalized for age-group analysis.
- **Revenue Data:** Purchase amounts are analyzed as recorded in the dataset because the currency and precise monetary unit are not specified.

## 🛠️ Tools & Technologies

- **SQL Server & SSMS** – Data exploration, data quality checks, aggregation, and business analysis
- **Power BI** – Interactive dashboards, KPI visualization, and player segmentation
- **DAX** – Calculated columns and measures for analytical reporting

## 📂 Project Structure

```text
mobile-game-monetization-analysis/
├── README.md
├── Mobile_Game_Monetization_SQL_Queries.sql
├── Mobile_Game_Monetization_Dashboard.pbix
└── images/
    ├── monetization_overview.png
    └── player_insights.png
```

## 🚀 How to Use

1. Open `Mobile_Game_Monetization_Dashboard.pbix` in Power BI Desktop to explore the interactive dashboard.
2. Use the available slicers to analyze player behavior by country, device, game genre, and spending segment.
3. Review `Mobile_Game_Monetization_SQL_Queries.sql` to understand the SQL queries used to investigate business questions and calculate analytical results.
4. Explore the dashboard previews below to see the main visualizations and analytical findings.
5. Refer to the key findings and business recommendations documented in this README.
6. A detailed analytical report will be added as a separate deliverable.

## 📸 Power BI Dashboard Preview

The interactive Power BI dashboard consists of two pages, providing an overview of monetization performance and a deeper analysis of player behavior.

### Page 1: Monetization Overview

This page presents key performance indicators, revenue contribution by spending segment, revenue by game genre, average recorded spending by device, and spending patterns across engagement levels.

<img width="1205" height="680" alt="1791968764011_9159608106794795039_9159608106794795039_cf45e1fca60cd0529d260f48c6f042ec" src="https://github.com/user-attachments/assets/44581eaf-4df0-4763-9d41-fac902f4294d" />

### Page 2: Player Insights

This page explores player distribution across spending segments and age groups, average recorded spending by age group, and spending-segment distribution across game genres.

<img width="1203" height="676" alt="1791968867783_9159608106794795039_9159608106794795039_ecfa82ef6949e9b67810152888b8dc85" src="https://github.com/user-attachments/assets/2794186e-400e-40a5-93c6-bfbabfabd0a9" />

*Note: The images provide static previews of the dashboard. Open the Power BI file in Power BI Desktop to interact with the visuals and filters.*

## 💡 Key Findings

### 1. Revenue Is Highly Concentrated Among Whale Players

Whale players represent only **2.25% of all players** but contribute **57.88% of total recorded revenue**.

| Spending Segment | Players | Total Recorded Revenue | Revenue Share |
|---|---:|---:|---:|
| Whale | 68 | 15,004,132 | 57.88% |
| Dolphin | 412 | 8,706,443 | 33.59% |
| Minnow | 2,544 | 2,210,938 | 8.53% |
| **Total** | **3,024** | **25,921,513** | **100.00%** |

This indicates substantial revenue concentration among a relatively small group of high-value players, making player retention an important area for further investigation.

### 2. Higher Engagement Is Associated with Higher Average Spending

High-engagement players demonstrate the highest average recorded spending, while medium-engagement players contribute the largest total revenue because they represent the largest group.

| Engagement Level | Players | Average Recorded Spend | Total Recorded Revenue |
|---|---:|---:|---:|
| Low Engagement | 624 | 6,453.57 | 3,872,142 |
| Medium Engagement | 1,768 | 8,951.01 | 15,109,308 |
| High Engagement | 632 | 11,566.77 | 6,940,063 |

These results suggest that engagement level is associated with spending behavior. However, the observed relationship does not establish that higher engagement directly causes higher spending.

### 3. Device Performance Reveals Different Revenue Patterns

- **Android:** Generates higher total recorded revenue, with 13,239,210 across 1,738 players.
- **iOS:** Generates lower total recorded revenue, with 11,778,960 across 1,226 players, but has higher average recorded spending per player.

The average recorded spend is approximately 10,102.02 for iOS players, compared with 7,946.70 for Android players.

This highlights the importance of evaluating both total revenue and average spending when comparing device performance.

### 4. Game Genre Performance Varies Across Categories

Battle Royale ranks highest in both total recorded revenue and average recorded spending among the observed game genres.

- **Battle Royale:** Total recorded revenue of 2,600,739 and average recorded spend of 14,529.27.
- **Racing:** Total recorded revenue of 2,558,147 and average recorded spend of 14,055.75.

These findings identify genres worth investigating further to understand the player characteristics and gameplay experiences associated with stronger monetization performance.

### 5. Spending Patterns Differ Across Age Groups

Average recorded spending varies across age groups. The Under 18 group has the highest observed average recorded spend at 10,294.88, followed closely by the 35–44 group at 10,249.23.

This result should be interpreted cautiously because the age variable required normalization and the dataset includes minors. It should not be treated as a recommendation to target minors with monetization campaigns.

### 6. Payment Methods Show Different Average Spending Levels

Debit Card users have the highest average recorded spending among the observed payment methods, at 12,127.06, followed by PayPal users at 10,475.86.

These differences may help guide further investigation into payment preferences and purchasing behavior. They do not establish that a particular payment method causes higher spending.

## 💼 Business Recommendations

- **Prioritize High-Value Player Retention:** Investigate player satisfaction, gameplay experience, and appropriate loyalty benefits to support the retention of high-value players.
- **Improve Player Engagement:** Explore gameplay features and player journeys associated with higher engagement, then test initiatives designed to improve engagement among lower-engagement groups.
- **Optimize Device-Specific Experiences:** Investigate differences in spending behavior between Android and iOS players, including potential differences in user experience and purchasing journeys.
- **Investigate High-Performing Genres:** Examine why Battle Royale and Racing show stronger recorded spending and determine whether these patterns persist across player segments and countries.
- **Evaluate Payment Experiences:** Investigate whether payment convenience, availability, or user preferences are associated with differences in purchasing behavior.
- **Apply Responsible Monetization Practices:** Ensure monetization strategies protect minors and avoid manipulative purchasing mechanisms.

These recommendations are opportunities for further investigation and testing rather than proven causal interventions.

## ⚠️ Limitations

- The dataset contains player-level records rather than detailed transaction-level histories.
- Missing values exist in demographic and purchase-related fields.
- The currency and precise unit of purchase amounts are not specified; revenue figures are therefore reported without a currency symbol.
- The Age variable appeared to be stored at ten times its expected value and was normalized for age-group analysis.
- The unit of AverageSessionLength is not confirmed, so it is not interpreted as minutes or seconds.
- The available LastPurchaseDate field does not provide a complete transaction timeline.
- Customer acquisition cost (CAC), return on ad spend (ROAS), and marketing campaign profitability cannot be calculated because acquisition costs and advertising expenditure are not available.
- The analysis identifies associations and descriptive patterns, not causal relationships.
- Retention rates, churn, cohort behavior, and revenue trends over time cannot be reliably established from the available player-level data.

## 📌 Conclusion

This project demonstrates an end-to-end data analytics workflow using SQL Server and Power BI to investigate mobile game monetization, player engagement, and spending behavior.

The analysis identifies substantial revenue concentration among Whale players, differences in average spending across engagement levels and devices, and variation in monetization performance across game genres and player characteristics.

By combining data quality assessment, SQL-based analysis, and interactive visualization, this project demonstrates how player-level data can be transformed into actionable business insights to support more informed monetization and retention decisions.

## 📚 References & Acknowledgements

- **Dataset:** Mobile Game Monetization Analysis: Driving ARPU through Behavioral Segmentation (Kaggle).
- **Tools:** Microsoft SQL Server, SQL Server Management Studio (SSMS), and Microsoft Power BI.

[*Add the exact dataset URL and relevant tool documentation before publication.*](https://www.kaggle.com/datasets/pratyushpuri/mobile-game-in-app-purchases-dataset-2025)

## 👤 Author
**Trieu Phuong Anh**   
GitHub: [@PAT3009](https://github.com/PAT3009)  
LinkedIn: https://www.linkedin.com/in/phuong-anh-trieu-30i9/
Email: phuonganht3009@gmail.com
