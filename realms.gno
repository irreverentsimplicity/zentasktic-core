// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)

// structs

type Realm struct {
	Id 			string `json:"realmId"`
	Name 		string `json:"realmName"`
}