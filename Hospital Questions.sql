USE Hospital
GO

--Question 1

SELECT * FROM Physician
SELECT * FROM Trained_In
SELECT * FROM or_procedure
SELECT * FROM Undergoes


SELECT P.Name
FROM
Trained_In T RIGHT JOIN Undergoes U
ON	T.Physician = U.Physician
AND t.Treatment = u.or_procedure
			LEFT JOIN Physician P
ON U.Physician = P.EmployeeID
WHERE T.Treatment IS NULL

--Question 2
--Step 1 (I did the same in Question 1)
SELECT T.Treatment, T.Physician, U.or_procedure, T.CertificationExpires, P.Name
FROM
Trained_In T RIGHT JOIN Undergoes U
ON	T.Physician = U.Physician
AND t.Treatment = u.or_procedure
			LEFT JOIN Physician P
ON U.Physician = P.EmployeeID
WHERE U.DateUndergoes > T.CertificationExpires

--Step 2
SELECT P.Name
FROM
Trained_In T RIGHT JOIN Undergoes U
ON	T.Physician = U.Physician
AND t.Treatment = u.or_procedure
			LEFT JOIN Physician P
ON U.Physician = P.EmployeeID
WHERE U.DateUndergoes > T.CertificationExpires

--Question 3
SELECT * FROM Appointment
SELECT * FROM Patient

SELECT P.Name AS 'patient_name', Ph.Name AS 'physician_name', Ph.EmployeeID AS 'Physician_ID',
		A.PrepNurse AS 'Nurse_Num', N.Name AS 'Nurse_name', A.Start_time, A.End_time, A.ExaminationRoom, P.PCP
FROM Appointment A JOIN Patient P
ON A.Patient = P.SSN
					JOIN Physician Ph
ON A.Physician = Ph.EmployeeID
					 LEFT JOIN Nurse N
ON N.EmployeeID = A.PrepNurse
WHERE A.Physician != P.PCP

--Question 4
SELECT * FROM Undergoes
SELECT * FROM Stay

SELECT *
FROM Stay S JOIN Undergoes U
ON S.Patient != U.Patient
AND S.StayID = U.Stay

--Question 5
SELECT * FROM Nurse
SELECT * FROM On_Call
SELECT * FROM Room 

SELECT N.Name
FROM On_Call oc JOIN Room R
ON oc.BlockFloor = R.BlockFloor
AND oc.BlockCode = R.BlockCode
				JOIN Nurse N
ON oc.Nurse = N.EmployeeID
WHERE RoomNumber = 123

--Question 6
SELECT Examinationroom, COUNT(*) AS 'Number_of_Appointments'
FROM Appointment
GROUP BY ExaminationRoom

--Question 7
SELECT Pa.Name 
FROM Prescribes Pr JOIN Patient Pa
ON pr.Physician = pa.PCP

--Question 8
SELECT Pa.Name 
FROM or_procedure P JOIN Undergoes U
ON P.Code = U.or_procedure
					JOIN Patient Pa
ON U.Patient = Pa.SSN
WHERE P.Cost > 5000

--Question 9
SELECT * FROM Appointment


SELECT P.Name , COUNT (A.AppointmentID) AS 'Cnt'
FROM Appointment A JOIN Patient P
ON A.Patient = P.SSN
GROUP BY P.Name
HAVING COUNT(A.AppointmentID) >= 2

--Question 10
SELECT * FROM Physician
SELECT * FROM Department


SELECT DISTINCT Pa.Name 
FROM Physician P LEFT JOIN Department D
ON P.EmployeeID = D.Head
				 JOIN Patient Pa
ON P.EmployeeID = Pa.PCP
WHERE d.Head IS NULL


			