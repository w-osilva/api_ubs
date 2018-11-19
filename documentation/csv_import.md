# CSV Import

From:
[http://repositorio.dados.gov.br/saude/unidades-saude/unidade-basica-saude/ubs.csv](http://repositorio.dados.gov.br/saude/unidades-saude/unidade-basica-saude/ubs.csv)

## Process 
The import can be performed through a rake task. We have two options to make it:

* rake **ubs:csv_import_batch**  
* rake **ubs:csv_import**

#### csv_import_batch
Will read the CSV file and process in batch (more fast)
#### ubs:csv_import 
Will read the CSV file and send each row to be processed in background (sidekiq queue)

###### Currently the import is being "triggered" in rake db:seed
## To do
* Schedule the **csv_import_job** to run daily.
