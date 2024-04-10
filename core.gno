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
/* todo: leave it to the client
func () GetZenStatus() (zenStatus string, err error) {
	// implementation
}
*/
func GetObjectJourney(objectType string, objectId string) (zenStatus string, err error) {
	// implementation
	var objectPaths []ObjectPath

	// Iterate over the Paths AVL tree to collect all ObjectPath objects.
	Paths.Iterate("", "", func(key string, value interface{}) bool {
		if objectPath, ok := value.(ObjectPath); ok {
			if objectPath.ObjectType == objectType && objectPath.Id == objectId {
				objectPaths = append(objectPaths, objectPath)
			}
		}
		return false // Continue iteration until all nodes have been visited.
	})


	// Create a ContextsObject with all collected contexts.
	objectJourney := &ObjectJourney{
		ObjectPaths: objectPaths,
	}

	// Use the custom MarshalJSON method to marshal the contexts into JSON.
	marshalledJourney, merr := objectJourney.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledJourney), nil
}


