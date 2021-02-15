using System.ServiceModel;
using System.ServiceModel.Web;

namespace CheckoutWebservice
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "ISms" in both code and config file together.
    [ServiceContract]
    public interface ISms
    {
        [OperationContract]
        void DoWork();

        [OperationContract]
        [WebInvoke]
        string Push(string MobileNo, string Msg, int Priority, int TypeID, string KeyCode);        
    }
}
