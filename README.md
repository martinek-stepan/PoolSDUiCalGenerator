# SDU Pool schedule iCal generator
Since the schedule for students to access the swimming pool is not very intuitive I wanted to create a generator that would transform it into iCal object.

Unfortunately, it turned to be impossible to get data in any computer-readable form from SDU, so I had to data-mine the schedule from PDF posted to the website.

The process is composed of these steps:
1.	 Retrieve PDF from website
2.	Check if it is different from the one we already have
3.	Convert PDF into XLSX using 3rd party web service
4.	Parse XLSX to retrieve data
5.	Generate iCal
6.	Rename newPdf to oldPdf for comparison in next iteration
