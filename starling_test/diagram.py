from diagrams import Diagram, Cluster
from diagrams.custom import Custom
from diagrams.onprem.container import Docker
from diagrams.onprem.database import Postgresql
from diagrams.onprem.analytics import Metabase

with Diagram("dbt only", show=False, filename="dbt_diagram", direction="LR", curvestyle='curved'):
    with Cluster(""):
        results = [Custom("Tables", "./resources/database-table.jpg")]
        dbt = Custom("dbt", "./resources/dbt-logo.png")
        db = Postgresql("PostgreSQL")
        dbt >> db >> results
        Docker("Docker") >> db

with Diagram("dbt with metabase", show=False, filename="dbt_metabase_diagram", direction="LR", curvestyle='curved'):
    with Cluster("App"):
        docker = Docker("Docker")
        db = Postgresql("PostgreSQL")
        dashboard = Metabase("Metabase")
        # streamlit = Custom("Streamlit", "./resources/streamlit.png")
        # ui = Custom("Dashboard", "./resources/ui.png")
        dbt = Custom("dbt", "./resources/dbt-logo.png")
        results = Custom("Tables", "./resources/database-table.jpg")
        # api = Custom("Source", "./resources/api.png")
        docker >> dashboard >> ui
        docker >> db
        dbt >> db >> results >> dashboard

