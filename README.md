<h1>Project Title: Automating Snowflake via Terraform.</h1>

<b>Project Description:</b> This Terraform module can be used to completely automate a user's Snowflake environment. I have built this in a module-wise approach namely: database, schema, roles, users, warehouse and grants. Based on the environment name and the user credentials the entire infrastruucture can be automated and built at the earliest.

<b><i>Initial publish: 25/11/2022.
Author: Sayan Adhikary.
Github: https://github.com/isayan58/Terraform_3.0</i></b>

<h4>Update as on 25/11/2022.</h4>
<b><i>Functionalities:</i></b>
1. Database creation as mention in the YAML file in database module.<br/>
2. Schema creation as mention in the YAML file in schema module.<br/>
3. Roles created. RBAC hierarchy created.<br/>
4. Users created along with roles granted to them.<br/>
5. Role-specific warehouse created.<br/>
6. Grants provided to for all the necessary database objects.<br/>
<br/>
<b><i>Limitations:</i></b>
1. The providers are currently created in each separate module. Due to this reason the dependency cannot be created successfully. The providers should be created externally for each system roles and used as and when required.<br/>
2. The credentials are currently stored in variable.tf file. This needs to be hidden so that the credentials are never exposed to anyone.<br/>
3. This code currently has the basic items required in a Snowflake environment. Extra features need to be added and implemented successfully.<br/>
<br/><i>
P.S.: The tables need to be created via DDLs as it is more optimal compared to table creation via Terraform.</i>

<br/><br/>
<h4>Update as on 02/12/2022.</h4><br/>
Limitation #1 removed. Now the providers are not created in each module. The providers are created in the root folder and then the required providers are passed to the corresponding modules.
Since the provider is called from the root folder, dependencies on modules can be added as well.

<b><i>Limitations as on 02-Dec-2022:</i></b>
1. The credentials are currently stored in variable.tf file. This needs to be hidden so that the credentials are never exposed to anyone.<br/>
2. This code currently has the basic items required in a Snowflake environment. Extra features need to be added and implemented successfully.<br/>
<br/>
<i>P.S.: For the grants module we have to make sure that the provider has a warehouse as follows:</i>
    <div style = "color:#AA00AA; font-size:20px;">provider "snowsql" {<br/>
    alias = "securityadmin"<br/>
    username  = "SAYAN"<br/>
    account   = "<account locator>"<br/>
    region    = "<region>"<br/>
    password  = "<password>"<br/>
    role      = "SECURITYADMIN"<br/>
    warehouse = "TEST_WH"<br/>
    }</div>
<i>This is required for running the DCL commands using SnowSQL.</i>
