# TF2

***Note: If you try to run terraform in this folder, it will error out as terraform will try to run both *.tf files. Rename one of the files or remove it to avoid errors***

## Overview

This is an example of how to use variables and create multiple resource of the same type.

We start with a simple structure that repeats itself 3 times to create 3 resource groups.

## Variables

To use variables, we must declare them. As we learned in last session, you can create the declaration anywhere in the file, and Terraform will know to use the correct ones. One thing to note is that variables are usually globally scoped, the exception are variables used inside modules and local variables.

The declaration looks like this:

```terraform
variable "resource_group_location" {
  description = "The Resource Group Location"
  type        = string
  default     = "North Europe"
}
```

Here we find a new keyword - **variable** followed by the name of the variable. Within the declaration we have to supply at least the **type** but it is a good practice to also supply a **description**. You can also supply a default value. If you don’t, when you execute any Terraform command, it will request that you supply a value for the variable showing the description provided, or fail if it cannot find a value.

To read more about variables, view: <https://www.terraform.io/language/values/variables>. It is encouraged to get familiar with variable types, validations, sensitivity.

When we want to reference a variable value in a resource or module block, we use the following method:

```terraform
  location = var.resource_group_location
```

This tells Terraform to look for all the variables, depicted by the usage of **var** keyword followed by the variable name **resource_group_location** and use its value.

This naturally makes it easier to reuse the same values and apply **DRY** methodology.

Now let's see how we can reduce the amount of script required to create the same resource multiple times with specific values for each instance. This is shown in main.1.tf file.

We declare a variable **resource_group_names** that is of type List of strings (basically an array), that holds the names of the Resource Groups we want to create.

```terraform
variable "resource_group_names" {
  description = "The Names of all Resource Groups"
  type        = list(string)
  default     = ["RG1","RG2","RG3"]
}
```

Then in the resource declaration we use the property **count** that is equal to the result of the function **length** over the list of values inside the variable declared. This is the equivalent of a For Loop in other programming languages.

We then use the **count.index** function in square brackets to iterate over the values inside the variable, based on their index position in the list.

```terraform
resource "azurerm_resource_group" "rg" {
  count    = length(var.resource_group_names)
  name     = var.resource_group_names[count.index]
  location = var.resource_group_location
}
```

The result will be 3 resource groups being created, each with a different value for the resource group name.
