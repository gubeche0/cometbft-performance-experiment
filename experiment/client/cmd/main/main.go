package main

import (
	"cometbft-client-experiment/internal"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"sync"
	"sync/atomic"
	"time"

	"github.com/gorilla/websocket"
)

var (
	outputFile        = flag.String("output", "log.txt", "Output file to write the logs")
	rpcAddress        = flag.String("rpc", "http://localhost:26657", "Address of the RPC server")
	webSocket         = flag.String("ws", "ws://localhost:26657/websocket", "Address of the WebSocket server")
	totalTx           = flag.Int("totalTx", 0, "Total number of transactions to send. 0 means infinite transactions")
	totalConcurrentTx = flag.Int("totalConcurrentTx", 1, "Total number of concurrent transactions to send")
)

var (
	transactionsWaitGroup = sync.WaitGroup{}

	currentBlockHeight = atomic.Int64{}

	running    = atomic.Bool{}
	loggerChan = make(chan string, 50)
)

func main() {
	flag.Parse()

	f, err := os.Create(*outputFile)
	if err != nil {
		panic(err)
	}

	defer f.Close()
	running.Store(true)
	listenNewBlocks()

	// TODO: Get the current block height from the RPC server
	currentBlockHeight.Store(-1)
	transactionsWaitGroup.Add(*totalConcurrentTx)
	for i := 0; i < *totalConcurrentTx; i++ {
		go workTransaction(*totalTx)
	}

	go func() {
		transactionsWaitGroup.Wait()
		running.Store(false)
		close(loggerChan)
	}()

	for log := range loggerChan {
		_, err := f.WriteString(log + "\n")
		if err != nil {
			panic(err)
		}
	}
}

func logInFile(logStr string) {
	if running.Load() {
		loggerChan <- logStr
	}
}

func listenNewBlocks() {
	subscribeRequest := `{"jsonrpc":"2.0","method":"subscribe","params":["tm.event='NewBlock'"],"id":"1"}`
	c, _, err := websocket.DefaultDialer.Dial(*webSocket, nil)
	if err != nil {
		panic(err)
	}

	go func() {
		defer c.Close()
		for {
			_, message, err := c.ReadMessage()
			if err != nil {
				log.Println("read:", err)
				return
			}

			var NewBlock internal.NewBlock
			json.Unmarshal(message, &NewBlock)
			if NewBlock.Result.Data.Value.Block.Header.Height != "" {
				newHeight, err := strconv.ParseInt(NewBlock.Result.Data.Value.Block.Header.Height, 10, 64)
				if err != nil {
					log.Println(err)
					continue
				}

				curentBlock := currentBlockHeight.Load()
				if newHeight > curentBlock {
					currentBlockHeight.CompareAndSwap(curentBlock, newHeight)
				}

				totalTxs := len(NewBlock.Result.Data.Value.Block.Data.Txs)
				timeInTransaction := NewBlock.Result.Data.Value.Block.Header.Time
				timeNow := time.Now().UTC().Format(time.RFC3339Nano)
				logInFile(fmt.Sprintf("NewBlock;%d;%d;%s;%s", newHeight, totalTxs, timeInTransaction, timeNow))
			}
		}
	}()

	err = c.WriteMessage(websocket.TextMessage, []byte(subscribeRequest))
	if err != nil {
		panic(err)
	}
}

func workTransaction(totalTx int) {
	x := 0
	defer transactionsWaitGroup.Done()
	for (x < totalTx) || (totalTx == 0) {
		// Generate 1KB transaction
		transaction := generateTransaction(1024)
		tx := url.QueryEscape(string(transaction))

		start := time.Now()
		startBlockHeight := currentBlockHeight.Load()

		resp, err := http.Get(fmt.Sprintf("%s/broadcast_tx_commit?tx=\"%s\"", *rpcAddress, tx))
		if err != nil {
			// TODO: Tratar erro
			panic(err)
		}

		elapsed := time.Since(start)
		var CommitTx internal.CommitTx
		json.NewDecoder(resp.Body).Decode(&CommitTx)
		// TODO: Tratar erros com status code 200

		if CommitTx.Result.Height != "" {
			newHeight, err := strconv.ParseInt(CommitTx.Result.Height, 10, 64)
			if err != nil {
				panic(err)
			}
			if newHeight > startBlockHeight {
				currentBlockHeight.CompareAndSwap(startBlockHeight, newHeight)
			}
		} else {
			fmt.Println("Height is empty")
		}

		finalBlockHeight := currentBlockHeight.Load()
		timeStart := start.UTC().Format(time.RFC3339Nano)
		timeNow := time.Now().UTC().Format(time.RFC3339Nano)
		logInFile(fmt.Sprintf("transaction;%s;%d;%d;%s;%s;%s", resp.Status, startBlockHeight, finalBlockHeight, elapsed, timeStart, timeNow))

		resp.Body.Close()
		x++
	}
}

// Generate random transaction data
func generateTransaction(size int) string {
	transaction := make([]byte, size)
	rand.Read(transaction)

	return base64.StdEncoding.EncodeToString(transaction)
}
