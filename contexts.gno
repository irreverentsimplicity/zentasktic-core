// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)


type Context struct {
	Id 			string `json:"contextId"`
	Name 		string `json:"contextName"`
}

// contexts

func (Context ct) AddContext() (err error) {
	// implementation
}

func (Context ct) RemoveContext() (err error) {
	// implementation
}

func (Context ct) AddContextToTask(t Task) (err error) {
	// implementation
}

func (Context ct) AddContextToProject(p Project) (err error) {
	// implementation
}