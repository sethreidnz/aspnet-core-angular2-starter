using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using AspnetCoreAngular2Starter.MVC.Models.Configuration;
using AspnetCoreAngular2Starter.MVC.Models;

namespace AspnetCoreAngular2Starter.MVC.Controllers
{
    public class HomeController : Controller
    {
        public HomeController(IOptions<FrontendConfigurationModel> optionsAccessor)
        {
            Options = optionsAccessor.Value;
        }

        FrontendConfigurationModel Options { get; }

        public IActionResult Index()
        {
            string appHash = Options.MainHash;
            string vendorHash = Options.VendorHash;
            string chunkHash = Options.ChunkHash;
            string polyfillsHash = Options.PolyfillsHash;
            string frontendHost = Options.ScriptHost;   
            var viewModel = new HomeModel()
            {
                VendorScriptUrl = getScriptUrl("vendor.bundle.js", vendorHash, frontendHost),
                AppScriptUrl = getScriptUrl("main.bundle.js", appHash, frontendHost),
                ChunksScriptUrl = getScriptUrl("1.chunk.js", chunkHash, frontendHost),
                PolyfillsScriptUrl = getScriptUrl("polyfills.bundle.js", polyfillsHash, frontendHost)
            };
            return View(viewModel);
        }

        private string getScriptUrl(string scriptName, string scriptHash, string scriptHost)
        {
            if (string.IsNullOrWhiteSpace(scriptHash))
            {
                return $"{scriptHost}/{scriptName}";
            }
            return $"{scriptHost}/{scriptHash}/{scriptName}";
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
