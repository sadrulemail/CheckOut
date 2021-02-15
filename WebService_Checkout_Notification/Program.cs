using System.ServiceProcess;

namespace WebService_Checkout_Notification
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
				new CheckoutNotificationService() 
			};
            ServiceBase.Run(ServicesToRun);
        }
    }
}
