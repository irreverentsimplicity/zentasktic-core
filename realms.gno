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



func (r Realm) AddRealm() (err error){
	// implementation
	if Realms.Size() != 0 {
		existingRealm, exist := Realms.Get(r.Id)
		if exist {
			return ErrRealmIdAlreadyExists
		}
	}
	// check for hardcoded values
	if r.Id == "1" || r.Id == "2" || r.Id == "3" || r.Id == "4" {
		return ErrRealmIdNotAllowed
	}
	Realms.Set(r.Id, r)
	return nil
	
}

func (r Realm) RemoveRealm() (err error){
	// implementation
	realm := Realm{}
	if Realms.Size() != 0 {
		realm, exist := Realms.Get(r.Id)
		if !exist {
			return ErrRealmIdNotFound
		} else {
			// check for hardcoded values, not removable
			if r.Id == "1" || r.Id == "2" || r.Id == "3" || r.Id == "4" {
				return ErrRealmIdNotAllowed
			}
		}
	}
	
	_, removed := Realms.Remove(realm.(Realm).Id)
	if !removed {
		return ErrRealmNotRemoved
	}
	return nil
	
}

// getters
func GetRealmById(realmId string) (r Realm, err error) {
	// implementation
	if Realms.Size() != 0 {
		r, exist := Realms.Get(realmId)
		if exist {
			return r.(Realm), nil
		} else {
			return nil, ErrRealmIdNotFound
		}
	}
}

func GetRealms() (realms string, err error) {
	// implementation
	var allRealms []Realm

	// Iterate over the Context AVL tree to collect all Context objects.
	Realms.Iterate("", "", func(key string, value interface{}) bool {
		if realm, ok := value.(Realm); ok {
			allRealms = append(allRealms, realm)
		}
		return false // Continue iteration until all nodes have been visited.
	})


	// Create a RealmsObject with all collected contexts.
	realmsObject := &RealmsObject{
		Realms: allRealms,
	}

	// Use the custom MarshalJSON method to marshal the realms into JSON.
	marshalledRealms, rerr := realmsObject.MarshalJSON()
	if rerr != nil {
		return "", rerr
	} 
	return string(marshalledRealms), nil
}
