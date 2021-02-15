using System.ServiceProcess;

namespace Trust_Bank_Checkout_Email_Service
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[] 
			{ 
				new CheckOutEmailService() 
			};
            ServiceBase.Run(ServicesToRun);
        }
    }
}
