package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
        //"fmt"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

const apiUrl = "https://api.carbonintensity.org.uk"
const currentGenerationUrl = apiUrl + "/generation"
const pollingInterval = 5 * time.Minute

var (
        generationMixGauge = prometheus.NewGaugeVec(
                prometheus.GaugeOpts{
                        Name: "carbon_intensity_generation_mix",
                        Help: "Generation mix (percentage)",
                },
                []string{"fuel"},
        )


)

var client = http.Client{
	Timeout: time.Second * 10,
}

//{ 
//  "data":[{ 
//  "from": "2025-01-20T19:30Z",
//    "to": "2025-01-20T20:00Z",
//    "intensity": {
//      "forecast": 271,
//      "actual": 259,
//      "index": "very high"
//    }
//  }]
//}

//{"data":
//  {"from":"2025-01-20T19:30Z",
//   "to":"2025-01-20T20:00Z",
//   "generationmix":[
//       {"fuel":"biomass","perc":8.1},
//       {"fuel":"coal","perc":0},{"fuel":"imports","perc":8.8},{"fuel":"gas","perc":64.6},{"fuel":"nuclear","perc":8.9},{"fuel":"other","perc":0},{"fuel":"hydro","perc":0.3},{"fuel":"solar","perc":0},{"fuel":"wind","perc":9.3}
//      ]
//   }
//}


type AutoGenerated struct {
	Data Data `json:"data"`
}
type Generationmix struct {
	Fuel string  `json:"fuel"`
	Perc float64 `json:"perc"`
}
type Data struct {
	From          string          `json:"from"`
	To            string          `json:"to"`
	Generationmix []Generationmix `json:"generationmix"`
}

func poll() {
	go func() {
		for {
			err := update()
			if err != nil {
				log.Print("Error while updating: ", err)
			}
			time.Sleep(pollingInterval)
		}
	}()
}

func update() error {
	body, err := fetch(currentGenerationUrl)
	if err != nil {
		return err
	}
	current := AutoGenerated{}
	err = json.Unmarshal(body, &current)
	if err != nil {
		return err
	}
        for _, item := range current.Data.Generationmix {
           //fmt.Printf("%s %f\n", item.Fuel, item.Perc)
           generationMixGauge.WithLabelValues(item.Fuel).Set(item.Perc)
        }

	return nil
}

func fetch(url string) ([]byte, error) {
	log.Print("Fetching from " + url)
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}

	res, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	body, readErr := ioutil.ReadAll(res.Body)
	if readErr != nil {
		return nil, err
	}
	return body, err
}

func main() {
	log.SetOutput(os.Stdout)

	minimalRegistry := prometheus.NewRegistry()
	minimalRegistry.MustRegister(generationMixGauge)

	poll()

	handler := promhttp.HandlerFor(minimalRegistry, promhttp.HandlerOpts{})
	http.Handle("/", handler)
	http.ListenAndServe(":9200", nil)
}
