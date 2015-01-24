package main

import (
	// "crypto/tls"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
)

func main() {
	url_i := url.URL{}
	url_proxy, _ := url_i.Parse("http://1.171.97.17:80")

	// transport := http.Transport{}
	// transport.Proxy = http.ProxyURL(url_proxy)                        // set proxy
	// transport.TLSClientConfig = &tls.Config{InsecureSkipVerify: true} //set ssl

	// client := &http.Client{}
	// client.Transport = transport
	httpClient := &http.Client{Transport: &http.Transport{Proxy: http.ProxyURL(url_proxy)}}

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
}
