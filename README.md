# HR-Incident-Reporting

Employees are the roots of a company that contributes towards economic growth. Their prosperity and well-being henceforth become an essential aspect of the Human Resources department. 

The objective of the project is to design a multidimensional model from the provided dataset about Human Resource Incidents reported by employees. We have taken an open dataset of HR Incident Reporting. This dataset of employees consists of the reported incidents faced by them individually, the description of the incidents that occurred to them, the place and date of occurrence. The HR department needs to document information about an employee such as the number of incidents that happened to an employee, total number of incidents occurring at a particular location etcetera. 

 In this project, the main aim is to utilize the dataset and capture main aspects of data analytics. To do that, it is significant to design the data model to comprehend the fact tables and dimension tables. Once the model is designed, the data is ingested into the data warehouse. Once the data is setup, as a next step, various ETL (Extract, Transform and Load) operations are performed on the data. As a result, new findings are provided with the help of data visualization tool
 
 The data selected for the project is from the Human Resource domain. Based on any incident reported by any employee of an organization, the data represents the employee related various details like the first and last name, employee number, department, union, gender, hiring date and so on. Like employee related attributes, the data also contains columns related to the incident reported like date on which it took place, location, the date when it was reported by the employee and when the employee was back to work. Along with the incident, the injury information due to the incident is also given. The injury description, cause and its actions are the primary information of the injury. One of the most helpful data in the dataset is the claim number and its status representing once the employee reports an incident, it generates a claim number. And based on the history of the incident, the claim status is of four categories- Pending, approved, Not fully approved and denied. The other aspect of data is financial insight of the incident which includes Workers Compensation board cost and the other cost needed for the treatment of the employee and the same has been mentioned in the database as WCBCosts and OtherCosts. For any incident, based on the claim status the compensation cost or reimbursement cost is credited to the employee’s account. 
The dataset has 24 attributes and 365 records of incidents. The objective is to inspect the data and to develop a multidimensional model as a group and as well as individuals. The end goal is to analyze the data and present the visual aids to the end user. So, to do that, it is important to build Fact tables and dimension tables for the analysis of our dataset and then support it using visualization.

In this project, the main descriptive data analytics problem we will be dealing with is the incidents (accidents or injuries) occurred during the employment span of a particular employee. For all the individual incidents, employees are entitled to claim the amount spent by them for the treatment or as a recovery plan. These claims will be recorded in the form of WCB cost and other costs included in the process. Therefore, it is of utmost importance for the HR department to keep records of all the incidents taking place inside the company premises or during the work for the company. Here, the HR department is responsible for keeping the tracks of claims reported by the employees of the company and should be sent to the managerial department for the approval or denial of the claim. 
Hereby, we as a group are taking the following quantifiable measurements along analytical (decision) variables of interest within our application domain:
•	Total number of incidents of the employees.
•	Total number of incidents at a particular location.
•	Number of Claims posted by the employees on the organization portal.

In the project deliverable 1, we used operational dataset as follows:
•	Employee: This entity contains the demographical data of employees. It has the following attributes like EmpSerialNo, ClaimNo, EmpID, FirstName, LastName, Gender,     EmploymentStatus, HireDate, Position, CurrentUnion, DepartmentID, InjuryID, IncidentID, Department.
•	Claim: The claim entity claims details made by the employee and their status. The attributes are ClaimNo, ClaimStatus.
•	Injury: This entity describes the injury the employee faced. The attributes are InjuryID,
•	InjuryDescription.
•	Incident: The incident entity gives the details of the incident for a particular employee. It describes the time and place of its occurrence and when it was reported. The attributes are IncidentID, IncidentDate, DateReported, DateReturned, IncidentTypeDescription, Location and EmpID.
•	Department: The department entity has the information of the employee’s department and serial DepartmentID as the primary key.



