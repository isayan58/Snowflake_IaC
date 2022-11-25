Project Title: Automating Snowflake via Terraform.

Project Description: This Terraform module can be used to completely automate a user's Snowflake environment. I have built this in a module-wise approach namely: database, schema, roles, users, warehouse and grants. Based on the environment name and the user credentials the entire infrastruucture can be automated and built at the earliest.

Initial publish: 25/11/2022.
Author: Sayan Adhikary.
Github: https://github.com/isayan58/Terraform_3.0

Update as on 25/11/2022.
Functionalities:
1. Database creation as mention in the YAML file in database module.
2. Schema creation as mention in the YAML file in schema module.
3. Roles created. RBAC hierarchy created.
4. Users created along with roles granted to them.
5. Role-specific warehouse created.
6. Grants provided to for all the necessary database objects.

Limitations:
1. The providers are currently created in each separate module. Due to this reason the dependency cannot be created successfully. The providers should be created externally for each system roles and used as and when required.
2. The credentials are currently stored in variable.tf file. This needs to be hidden so that the credentials are never exposed to anyone.
3. Tables are not created using Terraform as it is easier to create the tables using DDLs.
4. This code currently has the basic items required in a Snowflake environment. Extra features need to be added and implemented successfully.