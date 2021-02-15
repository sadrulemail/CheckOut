namespace TblUrlCallingService
{
    partial class TblUrlCallingService
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.bWorker = new System.ComponentModel.BackgroundWorker();
            this.eventLog = new System.Diagnostics.EventLog();
            ((System.ComponentModel.ISupportInitialize)(this.eventLog)).BeginInit();
            // 
            // bWorker
            // 
            this.bWorker.WorkerSupportsCancellation = true;
            this.bWorker.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bWorker_DoWork);
            // 
            // eventLog
            // 
            this.eventLog.Log = "Application";
            this.eventLog.Source = "TBL URL Calling Service";
            // 
            // TblUrlCallingService
            // 
            this.ServiceName = "TBL URL Calling Service";
            ((System.ComponentModel.ISupportInitialize)(this.eventLog)).EndInit();

        }

        #endregion

        private System.ComponentModel.BackgroundWorker bWorker;
        public System.Diagnostics.EventLog eventLog;
    }
}
