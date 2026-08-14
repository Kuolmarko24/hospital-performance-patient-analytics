# Hospital Performance and Patient Analytics

An end-to-end data analytics project that transforms hospital data into actionable management information using **SQL Server** and **Microsoft Power BI**.

---

## 📌 Project Overview

The Hospital Performance and Patient Analytics project was developed to demonstrate a complete data analytics workflow—from data preparation and SQL analysis to interactive dashboard development and business insight.

The project analyzes hospital information across:

- Patients
- Doctors
- Appointments
- Treatments
- Billing and revenue

The final solution provides four Power BI dashboard pages covering executive performance, patient and clinical analytics, appointment operations, and treatment/revenue performance.

---

## 🎯 Business Problem

Hospital management needs a clear way to understand both operational and financial performance.

The project addresses questions such as:

- How many patients and doctors are represented?
- How many appointments are being handled?
- How are patients distributed by gender, age group, and insurance provider?
- How is appointment activity distributed across statuses, days, and hours?
- Where are no-shows and cancellations occurring?
- Which treatments, doctors, specializations, and branches contribute to revenue?
- How does revenue change over time?
- Which patients and doctors have the highest financial contribution?

The goal is to replace fragmented analysis with a structured, reproducible reporting solution.

---

## 🎯 Project Objectives

1. Clean and validate hospital data.
2. Prepare reliable SQL Server tables for analysis.
3. Develop SQL queries answering key business questions.
4. Create reusable SQL reporting views.
5. Build an interactive Power BI dashboard.
6. Present executive KPIs and detailed analytical insights.
7. Apply logical sorting, filtering, navigation, and formatting.
8. Perform final quality assurance and interactivity testing.
9. Document the complete analytical workflow.

---

## 📊 Dataset Scope

The completed project contains:

| Metric | Value |
|---|---:|
| Patients | 50 |
| Doctors | 10 |
| Appointments | 200 |
| Total Revenue | $551.25K |
| Average Bill | $2.76K |

The analytical model covers five main data domains:

- `patients_cleaned`
- `doctors_cleaned`
- `appointments_cleaned`
- `treatment_cleaned`
- `billing_cleaned`

---

## 🛠️ Tools & Technologies

### Database & Analytics
- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)

### Data Visualization
- Microsoft Power BI
- Power Query / Power BI data preparation
- DAX calculated measures where required

### Documentation
- Microsoft Word
- Markdown

### Project Management
- Structured SQL scripts
- Organized project folders
- Screenshot documentation
- Final QA and validation

---

## 🔄 Analytical Workflow

```text
Raw Hospital Data
       ↓
Data Cleaning & Validation
       ↓
Cleaned SQL Server Tables
       ↓
SQL Analytical Queries
       ↓
Reusable Reporting Views
       ↓
Power BI Data Model
       ↓
Interactive Dashboard
       ↓
Business Findings & Recommendations
```

The project was deliberately developed as an end-to-end pipeline rather than as a Power BI-only exercise.

---

# 🧹 Data Cleaning

The data preparation stage established the foundation for reliable analysis.

The cleaning workflow included activities such as:

- Reviewing data quality
- Identifying duplicate records
- Standardizing inconsistent values
- Reviewing missing values
- Validating dates
- Reviewing numeric fields
- Checking relationships between tables
- Preparing cleaned tables for analytical queries

The cleaned data was then used as the foundation for the SQL analytical layer.

More detail is available in:

`Documentation/02_Data_Cleaning_Report.docx`

---

# 🗄️ SQL Server Analysis

SQL Server forms the analytical foundation of the project.

The SQL work was separated into seven files:

| File | Purpose |
|---|---|
| `01_Database_and_Tables.sql` | Database and table setup |
| `02_Data_Cleaning_Patients.sql` | Data cleaning and preparation |
| `03_Patient_Clinical_Analytics.sql` | Patient and clinical analysis |
| `04_Appointment_Operational_Analytics.sql` | Appointment and operational analysis |
| `05_Treatment_Revenue_Analytics.sql` | Treatment and revenue analysis |
| `06_Executive_Analytics.sql` | Executive-level metrics and rankings |
| `07_Views.sql` | Reusable reporting views |

### SQL techniques demonstrated

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `INNER JOIN`
- `LEFT JOIN`
- `CASE`
- `COUNT`
- `COUNT(DISTINCT ...)`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `TOP`
- `CAST`
- `ROUND`
- `DATEPART`
- `DATENAME`
- Window functions
- `RANK()`
- SQL views

---

# 👥 Patient & Clinical Analytics

This analytical area focuses on the patient population and clinical workload.

The analysis includes:

- Patient gender distribution
- Patients by insurance provider
- Patients by age group
- Appointment volume by doctor
- Appointment volume by specialization
- Hospital branch activity
- Reasons for patient visits

Age groups were implemented with a dedicated sorting field:

```text
Under 30
30-39
40-49
50-59
60+
```

`Age_Group_Sort` ensures the categories appear in logical age order rather than alphabetical order.

---

# 📅 Appointment & Operational Analytics

The appointment analysis examines operational activity beyond the overall appointment count.

Areas analyzed include:

- Appointment status
- Appointment completion
- No-shows
- Cancellations
- Reasons for visits
- Monthly appointment trends
- Busiest days of the week
- Peak appointment hours
- Doctor-level no-show performance
- Cancellation patterns by specialization

These analyses provide a framework for understanding demand and operational efficiency.

---

# 💰 Treatment & Revenue Analytics

The financial analysis connects treatment activity to billing and revenue.

Areas analyzed include:

- Revenue by treatment type
- Average treatment cost
- Revenue by doctor
- Revenue by specialization
- Revenue by hospital branch
- Revenue by payment method
- Revenue by insurance provider
- Monthly revenue
- Highest-value treatment records
- Top five revenue-generating doctors

The top-five doctor filter was intentionally used to keep the ranking visual focused and readable.

---

# 📈 Executive Analytics

The executive analysis provides higher-level performance measures.

It includes:

- Total patients
- Total doctors
- Total appointments
- Total treatments
- Total revenue
- Average bill
- Revenue per appointment
- Completion rate
- No-show rate
- Average bill by insurance provider
- Monthly revenue
- Branch efficiency
- Highest-value patients
- Doctor revenue ranking

These measures allow management to interpret hospital performance from both operational and financial perspectives.

---

# 📊 Power BI Dashboard

The final Power BI report contains four pages.

## 1. Executive Overview

The Executive Overview is the landing page and provides the fastest view of overall performance.

### KPIs

- **Total Patients:** 50
- **Total Doctors:** 10
- **Total Appointments:** 200
- **Total Revenue:** $551.25K
- **Average Bill:** $2.76K

### Supporting visuals

- Revenue by Hospital Branch
- Patient Gender Distribution
- Patients by Insurance Provider
- Patients by Age Group
- Monthly Revenue Trend

The page also contains interactive slicers and the project navigation bar.

---

## 2. Patient and Clinical Analytics

This page provides deeper analysis of the patient population and clinical activity.

It focuses on:

- Patient demographics
- Gender
- Age groups
- Insurance providers
- Clinical workload
- Doctors
- Specializations
- Hospital branches
- Reasons for visits

---

## 3. Appointment and Operational Analytics

This page focuses on appointment behavior and operational performance.

It includes analysis of:

- Appointment status
- Completion
- No-shows
- Cancellations
- Monthly appointment activity
- Appointment days
- Appointment hours
- Doctor-level operational performance

---

## 4. Treatment and Revenue Analytics

This page focuses on financial and treatment performance.

It includes:

- Treatment revenue
- Treatment costs
- Revenue by doctor
- Revenue by specialization
- Revenue by branch
- Payment methods
- Monthly revenue
- Top five revenue-generating doctors

---

# 🎛️ Interactivity

The dashboard includes controlled interactivity through:

- Slicers
- Dropdown filters
- Page navigation
- Top-N filtering
- Logical category sorting
- Chronological month sorting

The navigation bar is available across the dashboard pages and allows users to move directly between pages.

The active page is visually indicated using dark blue to maintain navigation awareness without overpowering the main KPIs.

---

# 🎨 Dashboard Design Philosophy

A major design principle of this project is:

> **Clarity over complexity.**

The dashboard was deliberately refined to avoid unnecessary visual crowding.

Design decisions included:

- Clear business-friendly titles
- Consistent currency formatting
- Logical category sorting
- Limited number of visuals per page
- Dedicated slicer space
- Focused top-five rankings
- Consistent navigation
- Selective use of tooltips
- Strong visual hierarchy
- KPI-first presentation on the Executive Overview

The goal is to help a decision-maker understand the most important information quickly.

---

# 🔍 Key Confirmed Metrics

The completed project produces these confirmed headline metrics:

### 50 Patients
The dataset contains 50 patient records.

### 10 Doctors
The dataset contains 10 doctors.

### 200 Appointments
The dataset contains 200 appointment records.

### $551.25K Total Revenue
The billing records represent approximately $551.25K in total revenue.

### $2.76K Average Bill
The average billing amount is approximately $2.76K.

The project intentionally avoids presenting unverified rankings or percentages as confirmed findings.

---

# 💡 Business Value

The project demonstrates how hospital data can be transformed into management information.

It provides a framework for:

- Monitoring overall hospital performance
- Understanding patient demographics
- Evaluating clinical workload
- Monitoring appointment operations
- Identifying no-show and cancellation patterns
- Understanding treatment revenue
- Comparing doctor and branch performance
- Monitoring financial trends
- Supporting evidence-based decision-making

---

# 🧪 Quality Assurance

Final QA was performed after dashboard development.

The following were checked:

- Slicer behavior
- Page navigation
- Age-group sorting
- Month sorting
- Top-five filtering
- Currency formatting
- Visual naming
- Dashboard spacing
- Interactive behavior
- Overall visual clarity

The final QA stage was completed before documenting the project.

---

# 📁 Project Structure

```text
Hospital Performance and Patient Analytics/
│
├── SQL/
│   ├── 01_Database_and_Tables.sql
│   ├── 02_Data_Cleaning_Patients.sql
│   ├── 03_Patient_Clinical_Analytics.sql
│   ├── 04_Appointment_Operational_Analytics.sql
│   ├── 05_Treatment_Revenue_Analytics.sql
│   ├── 06_Executive_Analytics.sql
│   └── 07_Views.sql
│
├── Power BI/
│   └── Hospital_Performance_Analytics.pbix
│
├── Screenshots/
│   ├── Executive_Overview.png
│   ├── Patient_Clinical_Analytics.png
│   ├── Appointment_Operational_Analytics.png
│   └── Treatment_Revenue_Analytics.png
│
└── Documentation/
    ├── 01_Project_Overview.docx
    ├── 02_Data_Cleaning_Report.docx
    ├── 03_SQL_Analytics_Documentation.docx
    ├── 04_Power_BI_Dashboard_Documentation.docx
    ├── 05_Key_Findings_and_Business_Insights.docx
    └── 06_Project_Conclusion_and_Portfolio_Summary.docx
```

> Update the Power BI and screenshot filenames in this README if your actual filenames are different.

---

# 🧠 Skills Demonstrated

This project demonstrates practical experience with:

### Data Analytics
- Data cleaning
- Exploratory analysis
- KPI development
- Business-question formulation
- Insight generation

### SQL
- Data transformation
- Relational joins
- Aggregation
- Conditional logic
- Window functions
- Ranking
- Date analysis
- Reporting views

### Power BI
- Dashboard development
- KPI cards
- Interactive visuals
- Slicers
- Filtering
- Page navigation
- Sorting
- Data presentation
- Visual design

### Business Intelligence
- Executive reporting
- Operational analysis
- Financial analysis
- Clinical analytics
- Decision-support reporting

---

# 🚀 Future Improvements

Possible future improvements include:

- Adding more historical hospital data
- Automated data refresh
- Scheduled reporting
- Additional operational KPIs
- Expanded patient-value analysis
- More advanced doctor-performance analysis
- Predictive analytics using historical data
- Statistical analysis of appointment behavior
- Controlled stakeholder deployment of the Power BI report

---

# 📚 Documentation

Detailed project documentation is available in the `Documentation` folder:

1. **Project Overview**
2. **Data Cleaning Report**
3. **SQL Analytics Documentation**
4. **Power BI Dashboard Documentation**
5. **Key Findings and Business Insights**
6. **Project Conclusion and Portfolio Summary**

These documents provide additional detail about the methodology, technical implementation, dashboard design, findings, and business value.

---

# 🏁 Conclusion

The Hospital Performance and Patient Analytics project demonstrates an end-to-end analytics workflow:

```text
Data
 ↓
Cleaning
 ↓
SQL Analysis
 ↓
Reporting Views
 ↓
Power BI
 ↓
Dashboard
 ↓
Business Insights
```

The project combines technical SQL skills, data preparation, business analysis, visualization, dashboard design, and quality assurance into one practical solution.

The final deliverable is not simply a collection of charts. It is a reproducible analytical pipeline designed to turn hospital data into information that can support better understanding and decision-making.

---

## 👤 Portfolio Note

This project is suitable for demonstrating practical skills for roles such as:

- Junior Data Analyst
- Data Analyst
- Business Intelligence Analyst
- Reporting Analyst
- SQL Analyst
- Power BI Analyst

