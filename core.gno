// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)

// holding the path of an object since creation
// each time we move an object from one realm to another, we add to its path
type ObjectPath struct {
	ObjectType	string `json:"objectType"` // Task, Project
	Id 			string `json:"id"` // this is the Id of the object moved, Task, Project
	RealmId 	string `json:"realmId"`
}

var (
	Paths avl.Tree
	PathId int = 1
)

// entry point

func (o ObjectPath) AddPath() (err error){
	PathId++
	updated := Paths.Set(string(PathId), o)
	if !updated {
		return ErrObjectPathNotUpdated
	}
	return nil
}

// GetZenStatus
/*
func () GetZenStatus() (zenStatus string, err error) {
	// implementation
}

func () GetObjectZenStatus(objectType string, objectId string) (zenStatus string, err error) {
	// implementation
}

funct () GetAllPahts() (err error) {
	// implementation
}

*/