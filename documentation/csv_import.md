# CSV Import

From:
[http://repositorio.dados.gov.br/saude/unidades-saude/unidade-basica-saude/ubs.csv](http://repositorio.dados.gov.br/saude/unidades-saude/unidade-basica-saude/ubs.csv)

## Process 
The import can be performed through a rake task.

* rake **ubs:csv_import_batch**  


#### csv_import_batch
Will read the CSV file and process in batch (more fast)

## To do
* Schedule the **csv_import_job** to run daily.
