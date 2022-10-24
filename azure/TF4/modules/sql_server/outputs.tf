output "server_name" {
  value = azurerm_sql_server.mssql.fully_qualified_domain_name
}

output "server_id" {
  value = azurerm_sql_server.mssql.id
}