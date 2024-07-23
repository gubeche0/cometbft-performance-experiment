package internal

type CommitTx struct {
	Jsonrpc string `json:"jsonrpc"`
	ID      int    `json:"id"`
	Result  struct {
		Hash   string `json:"hash"`
		Height string `json:"height"`
		// CheckTx struct {} `json:"check_tx"`
		// DeliverTx struct {} `json:"deliver_tx"`
	} `json:"result"`
}
