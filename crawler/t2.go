package main

import (
	"fmt"
	"h12.me/socks"
	"io/ioutil"
	// "log"
	"net/http"
	"os"
)

func prepareProxyClient() *http.Client {
	dialSocksProxy := socks.DialSocksProxy(socks.SOCKS5, "202.118.250.234:1080")
	transport := &http.Transport{Dial: dialSocksProxy}
	return &http.Client{Transport: transport}
}

func httpGet(httpClient *http.Client, url string) (resp *http.Response, err error) {
	req, err := http.NewRequest("GET", url, nil)
	req.Header.Set("User-Agent", "curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8x zlib/1.2.5")
	resp, err = httpClient.Do(req)
	return
}

func httpGetBody(httpClient *http.Client, url string) (body string, err error) {
	resp, err := httpGet(httpClient, url)
	defer resp.Body.Close()
	bodyb, err := ioutil.ReadAll(resp.Body)
	body = string(bodyb)
	return
}

func main() {
	dialSocksProxy := socks.DialSocksProxy(socks.SOCKS5, "202.118.250.234:1080")
	tr := &http.Transport{Dial: dialSocksProxy}
	httpClient := &http.Client{Transport: tr}

	response, err := httpClient.Get("http://blog.linxiang.info/")
	if err != nil {
		fmt.Printf("%s", err)
		os.Exit(1)
	} else {
		fmt.Printf("%v\n", response)
		defer response.Body.Close()
		contents, err := ioutil.ReadAll(response.Body)
		if err != nil {
			fmt.Printf("%s", err)
			os.Exit(1)
		}
		fmt.Printf("\n", string(contents))
	}

	// clientPtr := prepareProxyClient()
	// body, _ := httpGetBody(clientPtr, "http://blog.linxiang.info")
	// log.Printf("%s", string(body))
}
