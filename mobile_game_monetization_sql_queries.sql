USE GameAnalytics;
GO

SELECT *
FROM dbo.mobile_game_inapp_purchases;

--- Section 1: Data preprocessing
-- 1. Total rows
SELECT COUNT(*) AS TotalRows
FROM dbo.mobile_game_inapp_purchases;

-- 2. Preview data
SELECT TOP 10 *
FROM dbo.mobile_game_inapp_purchases;
--- The dataset contains 3,024 player records, with information covering player demographics, game preferences, engagement behavior, spending segments, in-app purchase amounts, payment methods, and purchase-related dates. The initial preview confirms that the data has been imported into SQL Server and that the main columns are available for analysis. However, some missing values are visible and require further investigation before conducting business analysis.

-- 3. Check for duplicate UserID
SELECT
    UserID,
    COUNT(*) AS NumberOfRows
FROM dbo.mobile_game_inapp_purchases
GROUP BY UserID
HAVING COUNT(*) > 1;
--- No duplicate UserID values were identified. This suggests that each player is represented by a unique record, making the dataset suitable for player-level analysis without additional deduplication at this stage. 

-- 4. Check for NULL data
SELECT
    SUM(CASE WHEN UserID IS NULL THEN 1 ELSE 0 END) AS MissingUserID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS MissingAge,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS MissingCountry,
    SUM(CASE WHEN Device IS NULL THEN 1 ELSE 0 END) AS MissingDevice,
    SUM(CASE WHEN GameGenre IS NULL THEN 1 ELSE 0 END) AS MissingGameGenre,
    SUM(CASE WHEN SessionCount IS NULL THEN 1 ELSE 0 END) AS MissingSessionCount,
    SUM(CASE WHEN AverageSessionLength IS NULL THEN 1 ELSE 0 END) AS MissingSessionLength,
    SUM(CASE WHEN SpendingSegment IS NULL THEN 1 ELSE 0 END) AS MissingSpendingSegment,
    SUM(CASE WHEN InAppPurchaseAmount IS NULL THEN 1 ELSE 0 END) AS MissingPurchaseAmount,
    SUM(CASE WHEN FirstPurchaseDaysAfterInstall IS NULL THEN 1 ELSE 0 END) AS MissingFirstPurchaseDays,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod,
    SUM(CASE WHEN LastPurchaseDate IS NULL THEN 1 ELSE 0 END) AS MissingLastPurchaseDate
FROM dbo.mobile_game_inapp_purchases;
--- Missing values are concentrated in two groups of variables. Demographic and game preference fields contain 60 missing records each (1.98%), while purchase-related fields contain 136 missing records each (4.50%). Engagement variables and spending segments have no missing values. These gaps should be investigated before analysis, particularly because missing purchase amounts cannot automatically be interpreted as zero spending.

-- 5. Check invalid numeric values
SELECT *
FROM dbo.mobile_game_inapp_purchases
WHERE Age < 0 OR Age > 100
   OR SessionCount < 0
   OR AverageSessionLength < 0
   OR InAppPurchaseAmount < 0
   OR FirstPurchaseDaysAfterInstall < 0;
--- The numeric validation did not identify any records violating the specified conditions for age, session count, average session length, in-app purchase amount, or days after installation. However, this does not necessarily confirm that all numeric values are valid, as additional checks may be required to verify plausible ranges and the units of measurement used in the dataset.

-- 6. Check spending segments
SELECT
    SpendingSegment,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRevenue,
    AVG(InAppPurchaseAmount) AS AverageSpend
FROM dbo.mobile_game_inapp_purchases
GROUP BY SpendingSegment
ORDER BY TotalRevenue DESC;
--- Revenue is highly concentrated among Whale players, who represent only 2.25% of all players but contribute approximately 57.9% of total recorded revenue. Dolphins account for around 13.6% of players and 33.6% of revenue, while Minnows represent 84.1% of players but contribute only 8.5% of revenue. This indicates substantial differences in spending behavior across segments and suggests that player segmentation is important for understanding monetization performance.
---- The initial SQL audit confirms that the dataset contains 3,024 player records with no duplicate UserIDs. Missing values are relatively limited but concentrated in demographic and purchase-related fields. The segment-level analysis also reveals substantial revenue concentration among Whale players. Before proceeding to deeper monetization and behavioral analysis, missing values and numeric validity should be investigated, while revenue metrics should be interpreted in accordance with the dataset's definitions.

-- Section 2: Spending Segment & Revenue Analysis
-- Business objective: Understand how players are distributed across spending segments and how much revenue each segment contributes.
-- Questions:
--- Which spending segment contributes the most revenue?
--- What percentage of players belongs to each segment?
--- How concentrated is revenue among high-spending players?
---- 2.1. Player Distribution and Revenue Contribution
WITH SegmentSummary AS (
    SELECT
        SpendingSegment,
        COUNT(*) AS PlayerCount,
        SUM(InAppPurchaseAmount) AS TotalRevenue,
        AVG(InAppPurchaseAmount) AS AverageSpend
    FROM dbo.mobile_game_inapp_purchases
    GROUP BY SpendingSegment)

SELECT
    SpendingSegment,
    PlayerCount,
    ROUND(
        100.0 * PlayerCount /
        SUM(PlayerCount) OVER (), 2
    ) AS PlayerPercentage,
    TotalRevenue,
    ROUND(
        100.0 * TotalRevenue /
        SUM(TotalRevenue) OVER (), 2
    ) AS RevenuePercentage,
    ROUND(AverageSpend, 2) AS AverageSpend
FROM SegmentSummary
ORDER BY TotalRevenue DESC;
--- Key findings:
-- Whales represent only 2.25% of players but contribute 57.88% of recorded revenue.
-- Dolphins account for 13.62% of players and generate 33.59% of revenue.
-- Minnows make up 84.13% of players but contribute only 8.53% of revenue.
--- Business Insights: The analysis reveals a substantial concentration of revenue among high-spending players. Although Whales represent only 2.25% of the player base, they contribute 57.88% of total recorded revenue. Dolphins account for 13.62% of players and generate 33.59% of revenue, while Minnows represent the majority of players (84.13%) but contribute only 8.53% of revenue. These findings highlight the importance of spending-based segmentation in mobile game monetization. Whales are a major source of recorded revenue, while Dolphins may represent a segment worth investigating for potential monetization opportunities. However, the results are descriptive and do not establish that any particular retention or monetization strategy would increase revenue.

---- 2.2. Revenue Concentration
SELECT
    SUM(
        CASE
            WHEN SpendingSegment = 'Whale'
            THEN InAppPurchaseAmount
            ELSE 0
        END
    ) AS WhaleRevenue,

    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN SpendingSegment = 'Whale'
                THEN InAppPurchaseAmount
                ELSE 0
            END
        ) / NULLIF(SUM(InAppPurchaseAmount), 0), 2
    ) AS WhaleRevenueShare
FROM dbo.mobile_game_inapp_purchases;
--- Key findings:
-- Whale players generate 15,004,132 in recorded in-app purchase revenue, equivalent to 57.88% of total recorded revenue of 25,921,513. This indicates that the game's recorded monetization performance is highly dependent on a relatively small group of high-spending players.
-- From a business perspective, this concentration suggests that monitoring revenue contribution across spending segments is important. Nevertheless, the dataset does not provide sufficient longitudinal information to determine whether Whale players remain active over time or whether this revenue concentration is sustainable.

-- Section 3: Player Engagement Analysis
-- Business objective: Compare engagement metrics across spending segments.
--- 3.1. Engagement Metrics by Spending Segment
SELECT
    SpendingSegment,
    COUNT(*) AS PlayerCount,
    ROUND(AVG(CAST(SessionCount AS FLOAT)), 2) AS AvgSessionCount,
    ROUND(
        AVG(CAST(AverageSessionLength AS FLOAT)), 2
    ) AS AvgSessionLength
FROM dbo.mobile_game_inapp_purchases
GROUP BY SpendingSegment
ORDER BY
    CASE SpendingSegment
        WHEN 'Whale' THEN 1
        WHEN 'Dolphin' THEN 2
        WHEN 'Minnow' THEN 3
        ELSE 4
    END;
-- The engagement analysis shows relatively similar average session counts across the three spending segments. Whales have the highest average session count (10.93), compared with 10.12 for Dolphins and 10.04 for Minnows. However, Whales have a lower average session length (1,644.51) than both Dolphins (1,842.92) and Minnows (1,838.55).
-- These descriptive results suggest that higher spending is not necessarily associated with longer average sessions in this dataset. Whales appear to have slightly more sessions on average, but session frequency and session length alone may not fully explain differences in monetization. Further analysis of spending behavior and other player characteristics is needed before drawing stronger conclusions.

--- 3.2. Engagement and Spending Overview
-- Business objective: Examine spending patterns across engagement levels.
WITH EngagementGroups AS (
    SELECT
        CASE
            WHEN SessionCount < 8 THEN 'Low Engagement'
            WHEN SessionCount < 13 THEN 'Medium Engagement'
            ELSE 'High Engagement'
        END AS EngagementLevel,
        InAppPurchaseAmount
    FROM dbo.mobile_game_inapp_purchases)
SELECT
    EngagementLevel,
    COUNT(*) AS PlayerCount,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend,
    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue
FROM EngagementGroups
GROUP BY EngagementLevel
ORDER BY
    CASE EngagementLevel
        WHEN 'Low Engagement' THEN 1
        WHEN 'Medium Engagement' THEN 2
        WHEN 'High Engagement' THEN 3
        ELSE 4
    END;
-- Average recorded spending increases across the defined engagement groups, rising from 6,453.57 among Low Engagement players to 8,951.01 among Medium Engagement players and 11,566.77 among High Engagement players. High Engagement players therefore exhibit the highest average recorded spending, approximately 79.2% above the Low Engagement group.
-- Medium Engagement players generate the highest total recorded revenue (15,109,308), largely because this group contains the largest number of players. These findings indicate that engagement level is associated with differences in recorded spending, although the descriptive analysis does not establish a causal relationship between engagement and monetization.

-- Section 4 — Monetization Performance by Player Characteristics
--- 4.1: Monetization by Device
-- Business objective: Compare player spending across device types.
SELECT
    Device,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend
FROM dbo.mobile_game_inapp_purchases
GROUP BY Device
ORDER BY TotalRecordedRevenue DESC;
-- The device-level analysis shows that Android players generate the highest total recorded revenue (13,239,210), reflecting their larger representation in the dataset. However, iOS players have a higher average recorded spend of 10,102.02, compared with 7,946.70 for Android players, approximately 27.1% higher.
-- The 60 players with missing device information show an average recorded spend of 16,131.13. However, this group should be interpreted cautiously because its device type is unknown and the result may be influenced by a small number of high-spending players. Further investigation is needed before drawing conclusions about device-specific monetization performance.

--- 4.2: Monetization by Game Genre
-- Business objective: Compare recorded revenue and average spending across genres.
SELECT
    GameGenre,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend
FROM dbo.mobile_game_inapp_purchases
GROUP BY GameGenre
ORDER BY TotalRecordedRevenue DESC;
-- Monetization performance varies considerably across game genres. Battle Royale generates the highest total recorded revenue (2,600,739) and the highest average recorded spend (14,529.27), followed by Racing, with an average recorded spend of 14,055.75. Fighting and Strategy also show relatively high average spending, whereas Sandbox and Action RPG have lower average recorded spending.
-- These differences suggest that player spending patterns vary across genres in the dataset. However, the results are descriptive and do not establish that a particular genre causes higher spending. Differences may also reflect player composition, spending-segment distribution, or other characteristics. Further analysis is required before using these results to prioritize monetization initiatives.

-- Section 5 — Player Demographics & Payment Insights
---  5.1: Monetization by Age Group
-- Business objective: Compare recorded spending across player age groups.
--- Validate Age Values
SELECT
    Age,
    COUNT(*) AS PlayerCount
FROM dbo.mobile_game_inapp_purchases
WHERE Age IS NOT NULL
GROUP BY Age
ORDER BY Age;
--- Validation note: Age values range from 130 to 540, suggesting that age may be stored as actual age multiplied by 10. Therefore, divide Age by 10.0 to obtain interpretable age values before creating age groups. This assumption should be verified against the original dataset documentation.

WITH AgeGroups AS (
    SELECT
        Age / 10.0 AS NormalizedAge,
        CASE
            WHEN Age / 10.0 < 18 THEN 'Under 18'
            WHEN Age / 10.0 < 25 THEN '18-24'
            WHEN Age / 10.0 < 35 THEN '25-34'
            WHEN Age / 10.0 < 45 THEN '35-44'
            ELSE '45+'
        END AS AgeGroup,
        InAppPurchaseAmount
    FROM dbo.mobile_game_inapp_purchases
    WHERE Age IS NOT NULL)
SELECT
    AgeGroup,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend
FROM AgeGroups
GROUP BY AgeGroup
ORDER BY
    CASE AgeGroup
        WHEN 'Under 18' THEN 1
        WHEN '18-24' THEN 2
        WHEN '25-34' THEN 3
        WHEN '35-44' THEN 4
        WHEN '45+' THEN 5
    END;
--- Key findings:
-- The 35–44 age group generated the highest total recorded revenue (7,030,975), followed by players aged 25–34 (6,504,146).
-- Players under 18 had the highest average recorded spending (10,294.88), slightly above the 35–44 group (10,249.23).
-- The 18–24 group had the lowest average recorded spending (5,981.07), suggesting differences in monetization across age groups.
--- Business insight: The 25–44 age groups are important revenue contributors because of their high total recorded revenue. Meanwhile, the under-18 group’s relatively high average spending warrants further investigation before drawing conclusions about its monetization potential.

--- 5.2: Monetization by Payment Method
-- Business objective: Compare recorded spending across payment methods.
SELECT
    PaymentMethod,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRecordedRevenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend
FROM dbo.mobile_game_inapp_purchases
GROUP BY PaymentMethod
ORDER BY TotalRecordedRevenue DESC;
--- Key findings:
-- Debit Card generated the highest total recorded revenue (5,251,015) and the highest average recorded spending (12,127.06).
-- PayPal ranked second in total revenue (4,200,819), with an average recorded spend of 10,475.86.
-- Google Pay and Apple Pay had lower average recorded spending, at 7,009.28 and 7,109.32, respectively.
-- There were 136 records with a missing payment method and missing recorded revenue.
--- Business insight: Debit card and PayPal users are promising segments for further monetization analysis. However, these results show an association rather than a causal effect; payment preferences may overlap with differences in player characteristics and spending behavior.

-- Section 6: Monetization Opportunities
--- 6.1: Revenue Contribution by Spending Segment
-- Business objective: Identify the player segments contributing most to revenue.
WITH SegmentRevenue AS (
    SELECT
        SpendingSegment,
        COUNT(*) AS PlayerCount,
        SUM(InAppPurchaseAmount) AS TotalRevenue
    FROM dbo.mobile_game_inapp_purchases
    GROUP BY SpendingSegment)
SELECT
    SpendingSegment,
    PlayerCount,
    TotalRevenue,
    ROUND(
        TotalRevenue * 100.0 /
        NULLIF(SUM(TotalRevenue) OVER (), 0), 2
    ) AS RevenueSharePct
FROM SegmentRevenue
ORDER BY TotalRevenue DESC;
--- Key findings:
-- Whales accounted for the largest revenue contribution, generating 15,004,132, equivalent to 57.88% of total recorded revenue, despite representing only 68 players.
-- Dolphins contributed 33.59% of revenue, while Minnows accounted for only 8.53%.
-- Whales represented approximately 2.25% of all players, yet generated more than half of the recorded revenue.
--- Business insights: The results indicate a strong concentration of revenue among a small group of high-spending players. Game operators could prioritize retaining Whale players through personalized experiences and relevant offers, while encouraging suitable Minnow players to explore optional in-app purchases. However, monetization strategies should avoid excessive or manipulative spending pressure.

--- 6.2: Engagement and Monetization
-- Business objective: Compare recorded spending across engagement levels.
WITH EngagementGroups AS (
    SELECT
        CASE
            WHEN SessionCount < 8 THEN 'Low Engagement'
            WHEN SessionCount < 13 THEN 'Medium Engagement'
            ELSE 'High Engagement'
        END AS EngagementLevel,
        InAppPurchaseAmount
    FROM dbo.mobile_game_inapp_purchases)
SELECT
    EngagementLevel,
    COUNT(*) AS PlayerCount,
    SUM(InAppPurchaseAmount) AS TotalRevenue,
    ROUND(AVG(InAppPurchaseAmount), 2) AS AvgRecordedSpend
FROM EngagementGroups
GROUP BY EngagementLevel
ORDER BY
    CASE EngagementLevel
        WHEN 'Low Engagement' THEN 1
        WHEN 'Medium Engagement' THEN 2
        WHEN 'High Engagement' THEN 3
    END;
--- Key findings:
-- The High Engagement group had the highest average recorded spending per player, at 11,566.77.
-- The Medium Engagement group generated the highest total revenue (15,109,308), supported by its much larger player base of 1,768.
-- The Low Engagement group had the lowest average recorded spending, at 6,453.57.
---Business insights: Higher engagement is associated with higher average recorded spending in this dataset. However, Medium Engagement players contribute the most total revenue because there are substantially more of them. This suggests two potential opportunities: encourage low-engagement players to participate more actively, and improve monetization experiences for the large medium-engagement segment. These patterns are associations, not proof that increasing session count will directly increase spending.