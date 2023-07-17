using Microsoft.AspNetCore.Mvc;

namespace CpmPedidos.API.Controllers
{   
    public class AppBaseController : ControllerBase
    {
        protected readonly IServiceProvider serviceProvider;
        public AppBaseController(IServiceProvider serviceProvider)
        {           
            this.serviceProvider = serviceProvider;          
        }        
    }
}