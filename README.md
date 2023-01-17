# Welcome to your new dbt project!


# starling_test-analytics
Dbt project with postgres and metabase.


## Requirements
* dbt-core, dbt-postgres, pgadmin and metabase
* Docker Compose

# Run the dbt project without metabase

## Start the database container
```bash
docker compose up postgres pgadmin
```
This will create a postgres and pgadmin container from the image defined in the docker-compose.yaml file.

## Create a virtual environment (Windows)
```bash
pip install virtualenv
```
This will install the virtual environment package.
Now while in the project directory use the following command:
```bash
virtualenv env
```
All that is left is activating the environment.
```bash
\env\Scripts\activate.bat
```

## Create a virtual environment (Linux and MacOS)
Open terminal and install the package.
```bash
pip3 install virtualenv
```
To create the environment go to the project directory and type:
```bash
virtualenv venv
```
And to activate it use this command.
```bash
source venv/bin/activate
```

## Install dependencies
```bash
pip install -r requirements.txt
```
Make sure you are using a virtual environment for this. 

Now move inside the demo folder.
```bash
cd demo
```


## Install dbt packages 
Packages stated at the <b>packages.yml</b> file must be installed in order to use predefined functions, which in dbt are called <i>macros</i>.
Once they are installed, you are then able to call them via {{_}} Jinja tags. These type of functions can be called inside sql queries or independently. 

E.g.: {{ macro_name(<optional_parameters>)}}

Refer to https://hub.getdbt.com/ to check out packages and their usage.
```bash
dbt deps
```

## CSV to database tables
Seeds are CSV files in your dbt project (typically in your seeds directory), that dbt can load into your data warehouse using the ```dbt seed``` command.
```bash
dbt seed --profiles-dir ./profiles
```
Refresh the ```public_source``` schema of the ```postgres``` database to check that both csv-s are converted to database tables.

These are going to be used as the source for the rest of our models.


## Create and update models
Models can be translated as tables or views in the database language. These are called materialization types.
```bash
dbt run  --profiles-dir ./profiles

# To run a specific model use the --select <sql_file_name_of_the_model>
# E.g.:
dbt run  --select stg_ops_data --profiles-dir ./profiles
```

## Materialization types
Types: 
* View
* Table
* Ephemeral
* Incremental

All materializations are re-built everytime the ```dbt run``` command is executed. This results on re-processing the same records over and over again.

To filter the data to be processed, one can use the Incremental type of materialization
and define the filter rule like this:
```
    {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        [where condition on the sql query]

    {% endif %}
```

Ref: https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations

To fully refresh an incremental model use the following command:
```bash
dbt run --full-refresh --profiles-dir ./profiles
```


## Schema.yml file (i.e. stg_models.yml)

The model and its attributes are described. Transformation rules applied and assumptions are also recorded alongside the relevant attributes.
E.g.:
```
models:
  - name: stg_ops_data
    description: "customer service chat data over the period 2021-07-01 to 2022-06-29"
    columns:
      - name: ChatStartDate
        quote: false
        description: "The date a chat was initiated with an agent in customer services"
        tests:
          - not_null
```


## Run tests
Tests are SQL queries executed against the data to check for logical mistakes.

Types:
* Singular - built-in
* Generic  - custom tests

Singular tests are used inside the configuration yaml files. They have to be assigned to a column in order to run.
E.g.:
```
models:
  - name: stg_ops_data_source
    columns:
       - name: ChatID
         tests:
           - not_null
           - unique
```

To Run tests:
```bash
# Run all tests
dbt test --profiles-dir ./profiles

# Run singular tests
dbt test --select test_type:singular

# Run generic tests 
dbt test --select test_type:generic
```

## Docs and DAGs
Ref: https://docs.getdbt.com/docs/building-a-dbt-project/documentation

Update dbt documents
```bash
dbt docs generate --profiles-dir ./profiles
```
Check out the documentation and the data flow graph
```bash
dbt docs serve --profiles-dir ./profiles
```

## Configuration files
At this point you might have noticed the .yaml files. 

```src_covid_data.yml``` file holds the source tables and gives us a way to:
* Reference these tables with the ```{{ source(<source_name>, <table_name>) }}``` syntax
* Add descriptions at table or column level (view them on with ```docs serve```)
* Create a directed graph of dependencies between tables that shows the data flow.

```
demo
├─ models
│  ├─ staging
│  │  ├─ src_ops_data.yml
│  │  ├─ stg_models.yml
│  │  └─ *.sql

```

Same thing for ```stg_models.yml``` but for models instead of sources.


# Run the dbt project with pgadmin


## Open the UI
Use a browser to navigate to  http://localhost:5050 

Use admin@admin.com for the email address and 'postgres' as the password to log in.

Create the server with details as shown 

<img width="501" alt="Screenshot 2022-12-11 at 15 54 39" src="https://user-images.githubusercontent.com/118017659/206914115-ac60ba4d-3021-41d6-be86-6f5825c0eff7.png">

The resulting view is as shown below

<img width="1792" alt="Screenshot 2022-12-10 at 19 26 56" src="https://user-images.githubusercontent.com/118017659/206872108-bb3c6163-2dd4-4b4e-b7c0-d9d5f73d93ce.png">


## Stop the docker container
```bash
docker compose down
```


<hr>

# Run the dbt project with metabase

## Install requirements and create the docker containers

```bash
docker compose metabase up 
```

## Open the UI - Task 1 & 2
Use a browser to navigate to  http://localhost:3000

Sign in using email admin@admin.com and password p0stgres, the dashboard is available for viewing.

<img width="1782" alt="Screenshot 2022-12-10 at 19 12 26" src="https://user-images.githubusercontent.com/118017659/206871662-11182f20-b332-4988-ba00-d5888cc1eb54.png">

Chat Duration minutes is decreasing (maybe proactive steps were taken to address this) but no obvious pattern in Customer Wait time. Also calls closed by agents and customer have almost identical ratings. The number of calls appear to be on the increase (likely inline with customer base growing).


## Stop the docker container
```bash
docker compose down
```

