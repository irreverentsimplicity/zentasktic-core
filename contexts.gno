// base implementation
package zentasktic

import (
	"strconv"
	"errors"
	"time"

	"gno.land/p/demo/avl"
)


type Context struct {
	Id 			string `json:"contextId"`
	Name 		string `json:"contextName"`
}

var (
	Contexts avl.Tree // contextId -> Context
)

// actions

func (c Context) AddContext() (err error) {
	// implementation
	if Contexts.Size() != 0 {
		existingContext, exist := Contexts.Get(c.Id)
		if exist {
			return ErrContextIdAlreadyExists
		}
	}
	Contexts.Set(c.Id, c)
	return nil
}

func (c Context) EditContext() (err error){
	if Contexts.Size() != 0 {
		existingContext, exist := Contexts.Get(c.Id)
		if !exist {
			return ErrContextIdNotFound
		}
	}
	
	Contexts.Set(c.Id, c)
	return nil
}


func (c Context) RemoveContext() (err error) {
	// implementation
	context := Context{}
	if Contexts.Size() != 0 {
		context, exist := Contexts.Get(c.Id)
		if !exist {
			return ErrContextIdNotFound
		}
	}

	_, removed := Contexts.Remove(context.(Context).Id)
	if !removed {
		return ErrContextNotRemoved
	}
	return nil
}


func (c Context) AddContextToTask(t Task) (err error) {
	// implementation
	// check if task exists
	task, exist := Tasks.Get(t.Id)
	if !exist {
		return ErrTaskIdNotFound
	}
	// check if context exists
	context, cexist := Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	// check to see if task is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if t.RealmId == "2" {
		task.(Task).ContextId = c.Id
		Tasks.Set(t.Id, task.(Task))
	} else {
		return ErrTaskNotEditable
	}

	return nil
}


func (c Context) AddContextToProject(p Project) (err error) {
	// check if project exists
	project, exist := Projects.Get(p.Id)
	if !exist {
		return ErrProjectIdNotFound
	}
	// check if context exists
	context, cexist := Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	// check to see if project is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if p.RealmId == "2" {
		project.(Project).ContextId = c.Id
		Projects.Set(p.Id, project.(Project))
	} else {
		return ErrProjectNotEditable
	}

	return nil
}


// getters

func GetContextById(contextId string) (c Context, err error) {
	if Contexts.Size() != 0 {
		c, exist := Contexts.Get(contextId)
		if exist {
			return c.(Context), nil
		} else {
			return nil, ErrContextIdNotFound
		}
	}
	return nil, ErrContextIdNotFound
}

func GetAllContexts() (contexts string, err error) {
	// implementation
	var allContexts []Context

	// Iterate over the Context AVL tree to collect all Context objects.
	Contexts.Iterate("", "", func(key string, value interface{}) bool {
		if context, ok := value.(Context); ok {
			allContexts = append(allContexts, context)
		}
		return false // Continue iteration until all nodes have been visited.
	})


	// Create a ContextsObject with all collected contexts.
	contextsObject := &ContextsObject{
		Contexts: allContexts,
	}

	// Use the custom MarshalJSON method to marshal the contexts into JSON.
	marshalledContexts, merr := contextsObject.MarshalJSON()
	if merr != nil {
		return "", merr
	} 
	return string(marshalledContexts), nil
}