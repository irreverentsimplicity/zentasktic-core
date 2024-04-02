// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)

// structs

type Realm struct {
	Id 			string `json:"realmId"`
	Name 		string `json:"realmName"`
}

// initialize with hardcoded values: 1 Assess, 2 Decide, 3 Do, 4 Collections
var (
	Realms avl.Tree
)

/*

func (r Realm) AddRealm() (err error){
	// implementation
	// check for hardcoded values
}

func (r Realm) RemoveReaom() (err error){
	// implementation
	// check for hardcoded values, not removable
}

// getters
func () GetRealm(string realmId) (collections string, err error) {
	// implementation
}

func () GetRealms (realms string, err error) {
	// implementation
}
*/