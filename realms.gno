// base implementation
package zentasktic

import (
	"strconv"
	"errors"
)

// structs

type Realm struct {
	Id 			string `json:"realmId"`
	Name 		string `json:"realmName"`
}

/*
func () GetRealm(string realmId) (collections string, err error) {
	// implementation
}*/