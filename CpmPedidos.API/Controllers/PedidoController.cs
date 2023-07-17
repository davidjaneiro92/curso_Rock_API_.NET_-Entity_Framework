using Microsoft.AspNetCore.Mvc;

namespace CpmPedidos.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PedidoController : AppBaseController
    {
        private readonly IServiceProvider serviceProvider;
        public PedidoController(IServiceProvider serviceProvider): base (serviceProvider)
        {              
        }        
    }
}