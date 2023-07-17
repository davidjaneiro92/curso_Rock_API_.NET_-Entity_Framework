using CpmPedido.Repository;
using CpmPedidos.API;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Data.Common;

var builder = WebApplication.CreateBuilder(args);

 var DbConnection = new SqlConnection(builder.Configuration.GetConnectionString("conexao"));
 var aplicationDbContext = new AplicationDbContext();
// Add services to the container.

builder.Services.AddControllers();

IServiceCollection serviceCollection = builder.Services.AddDbContext<AplicationDbContext>(option =>
{
    option.UseSqlServer(DbConnection, assembly => assembly.MigrationsAssembly(typeof(AplicationDbContext).Assembly.FullName));
});

var app = builder.Build();


// Configure the HTTP request pipeline.

DependencyInjection.Register(builder.Services);

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
