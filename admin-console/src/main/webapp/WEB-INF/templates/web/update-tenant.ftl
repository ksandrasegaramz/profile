<h1 class="page-header">Update Tenant</h1>

<form role="form">
    <div class="form-group">
        <label for="name">Name</label>
        <input name="name" type="text" class="form-control" disabled="disabled" ng-model="tenant.name" />
    </div>

    <div class="checkbox">
        <label>
            <input type="checkbox" ng-model="tenant.verifyNewProfiles" /> Should profiles be verified when created?
        </label>
    </div>

    <div class="form-group">
        <div class="panel panel-default">
            <div class="panel-heading">
                <span class="form-panel-title">Available Roles</span>
            </div>
            <div class="panel-body">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Enter role to add" ng-model="roleToAdd"/>
                    <span class="input-group-btn">
                        <button class="btn btn-default" type="button" ng-click="addRole(roleToAdd)">Add</button>
                    </span>
                </div>

                <table class="table table-striped form-panel-table">
                    <tr ng-repeat="role in tenant.availableRoles">
                        <td>
                            {{role}}
                        </td>
                        <td>
                            <a ng-click="deleteRoleAt($index)">Delete</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="panel panel-default">
            <div class="panel-heading">
                <span class="form-panel-title">Attribute Definitions</span>
            </div>
            <div class="panel-body">
                <button class="btn btn-default" type="button"
                        ng-click="showAttributeDefinitionModal(definition, -1)">New definition</button>
                <table class="table table-striped form-panel-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Label</th>
                            <th>Type</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="definition in tenant.attributeDefinitions">
                            <td>
                                <a ng-click="showAttributeDefinitionModal(definition, $index)">{{definition.name}}</a>
                            </td>
                            <td>
                                {{definition.metadata.label}}
                            </td>
                            <td>
                                {{definition.metadata.type}}
                            </td>
                            <td>
                                <a ng-click="deleteAttributeDefinitionAt($index)">Delete</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</form>

<div id="attributeDefinitionModal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Attribute Definition</h4>
            </div>
            <div class="modal-body">
                <form role="form">
                    <div class="form-group">
                        <label for="name">Name</label>
                        <input name="name" type="text" class="form-control"
                               ng-model="currentDefinition.name" />
                    </div>

                    <div class="form-group">
                        <label for="attribDefLabel">Label</label>
                        <input name="label" type="text" class="form-control"
                               ng-model="currentDefinition.metadata.label" />
                    </div>

                    <div class="form-group">
                        <label for="type">Type</label>
                        <select name="type" class="form-control" ng-model="currentDefinition.metadata.type"
                                ng-options="attributeType for attributeType in attributeTypes"></select>
                    </div>

                    <div class="form-group">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <span class="form-panel-title">Attribute Permissions</span>
                            </div>
                            <div class="panel-body">
                                <div class="input-group">
                                    <input type="text"
                                           class="form-control"
                                           placeholder="Enter application name (* for any)"
                                           ng-model="application"/>
                                    <span class="input-group-btn">
                                        <button class="btn btn-default" type="button"
                                                ng-click="addPermission(currentDefinition, application)">Add</button>
                                    </span>
                                </div>
                                <table class="table form-panel-table">
                                    <thead>
                                        <tr>
                                            <th>Application</th>
                                            <th class="col-centered"
                                                ng-repeat="(actionName, actionLabel) in attributeActions">
                                                {{actionLabel}}
                                            </th>
                                            <th class="col-centered"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="permission in currentDefinition.permissions">
                                            <td>
                                                {{permission.application}}
                                            </td>
                                            <td class="col-centered"
                                                ng-repeat="(actionName, actionLabel) in attributeActions">
                                                <input name="actions[]"
                                                       type="checkbox"
                                                       value="{{actionName}}"
                                                       ng-checked="hasAction(permission, actionName)"
                                                       ng-click="toggleAction(permission, actionName)"/>
                                            </td>
                                            <td class="col-centered">
                                                <a ng-click="deletePermissionAt(currentDefinition, $index)">Delete</a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary"
                        ng-click="saveAttributeDefinition(currentDefinition, currentDefinitionIndex)">Save changes</button>
            </div>
        </div>
    </div><
</div>