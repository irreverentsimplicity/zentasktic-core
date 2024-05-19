// base implementation
package zentasktic

import (
	"strconv"
	"errors"
	"time"

	"gno.land/p/demo/avl"
)

type Context struct {
	Id   string `json:"contextId"`
	Name string `json:"contextName"`
}

type ZContextManager struct {
	Contexts avl.Tree
}

func NewZContextManager() *ZContextManager {
	return &ZContextManager{
		Contexts: avl.New(),
	}
}

// Actions

func (zcm *ZContextManager) AddContext(c Context) error {
	if zcm.Contexts.Size() != 0 {
		_, exist := zcm.Contexts.Get(c.Id)
		if exist {
			return ErrContextIdAlreadyExists
		}
	}
	zcm.Contexts.Set(c.Id, c)
	return nil
}

func (zcm *ZContextManager) EditContext(c Context) error {
	if zcm.Contexts.Size() != 0 {
		_, exist := zcm.Contexts.Get(c.Id)
		if !exist {
			return ErrContextIdNotFound
		}
	}
	zcm.Contexts.Set(c.Id, c)
	return nil
}

func (zcm *ZContextManager) RemoveContext(c Context) error {
	if zcm.Contexts.Size() != 0 {
		context, exist := zcm.Contexts.Get(c.Id)
		if !exist {
			return ErrContextIdNotFound
		}
		_, removed := zcm.Contexts.Remove(context.(Context).Id)
		if !removed {
			return ErrContextNotRemoved
		}
	}
	return nil
}

func (zcm *ZContextManager) AddContextToTask(ztm *ZTaskManager, c Context, t Task) error {
	taskInterface, exist := ztm.Tasks.Get(t.Id)
	if !exist {
		return ErrTaskIdNotFound
	}
	contextInterface, cexist := zcm.Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	if t.RealmId == "2" {
		task := taskInterface.(Task)
		task.ContextId = c.Id
		ztm.Tasks.Set(t.Id, task)
	} else {
		return ErrTaskNotEditable
	}

	return nil
}

func (zcm *ZContextManager) AddContextToProject(zpm *ZProjectManager, c Context, p Project) error {
	projectInterface, exist := zpm.Projects.Get(p.Id)
	if !exist {
		return ErrProjectIdNotFound
	}
	contextInterface, cexist := zcm.Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	if p.RealmId == "2" {
		project := projectInterface.(Project)
		project.ContextId = c.Id
		zpm.Projects.Set(p.Id, project)
	} else {
		return ErrProjectNotEditable
	}

	return nil
}

// Getters

func (zcm *ZContextManager) GetContextById(contextId string) (Context, error) {
	if zcm.Contexts.Size() != 0 {
		cInterface, exist := zcm.Contexts.Get(contextId)
		if exist {
			return cInterface.(Context), nil
		}
		return Context{}, ErrContextIdNotFound
	}
	return Context{}, ErrContextIdNotFound
}

func (zcm *ZContextManager) GetAllContexts() (string, error) {
	var allContexts []Context

	// Iterate over the Contexts AVL tree to collect all Context objects.
	zcm.Contexts.Iterate("", "", func(key string, value interface{}) bool {
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

func (zcm *ZContextManager) AddContextToTask(ztm *ZTaskManager, c Context, t Task) (err error) {
	// implementation
	// check if task exists
	task, exist := ztm.Tasks.Get(t.Id)
	if !exist {
		return ErrTaskIdNotFound
	}
	// check if context exists
	context, cexist := zcm.Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	// check to see if task is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if t.RealmId == "2" {
		task.(Task).ContextId = c.Id
		ztm.Tasks.Set(t.Id, task.(Task))
	} else {
		return ErrTaskNotEditable
	}

	return nil
}


func (zcm *ZContextManager) AddContextToProject(zpm *ZProjectManager, c Context, p Project) (err error) {
	// check if project exists
	project, exist := zpm.Projects.Get(p.Id)
	if !exist {
		return ErrProjectIdNotFound
	}
	// check if context exists
	context, cexist := zcm.Contexts.Get(c.Id)
	if !cexist {
		return ErrContextIdNotFound
	}

	// check to see if project is in RealmId = 2 (Decide)
	// we can only add resources in Decide
	if p.RealmId == "2" {
		project.(Project).ContextId = c.Id
		zpm.Projects.Set(p.Id, project.(Project))
	} else {
		return ErrProjectNotEditable
	}

	return nil
}


// getters

func (zcm *ZContextManager) GetContextById(contextId string) (c Context, err error) {
	if zcm.Contexts.Size() != 0 {
		c, exist := zcm.Contexts.Get(contextId)
		if exist {
			return c.(Context), nil
		} else {
			return Context{}, ErrContextIdNotFound
		}
	}
	return Context{}, ErrContextIdNotFound
}

func (zcm *ZContextManager) GetAllContexts() (contexts string, err error) {
	// implementation
	var allContexts []Context

	// Iterate over the Context AVL tree to collect all Context objects.
	zcm.Contexts.Iterate("", "", func(key string, value interface{}) bool {
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