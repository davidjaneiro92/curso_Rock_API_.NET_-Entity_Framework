using CpmPedido.Repository;
using CpmPedidos.API;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Data.Common;

var builder = WebApplication.CreateBuilder(args);

System.Net.ServicePointManager.ServerCertificateValidationCallback =
    (sender, certificate, chain, sslPolicyErrors) => true;

var DbConnection = new SqlConnection(builder.Configuration.GetConnectionString("App"));
var aplicationDbContext = new ApplicationDbContext(
    new DbContextOptionsBuilder<ApplicationDbContext>()
        .UseSqlServer(DbConnection, options => options.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName))
        .Options);
// Add services to the container.

builder.Services.AddControllers();

//IServiceCollection serviceCollection = builder.Services.AddDbContext<ApplicationDbContext>(option =>
//{
//    option.UseSqlServer(DbConnection, assembly => assembly.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName));
//});

var app = builder.Build();

// Configure the HTTP request pipeline.

DependencyInjection.Register(builder.Services);

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
