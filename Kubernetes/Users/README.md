##Create Certificate for User

##Generate private key:

openssl genrsa -out dev.key 2048

##Generate csr for user to get it signed by kubenetes (signing request)

openssl req -new -key dev.key -out dev.csr -subj "/CN=dev/O=java"

cat dev.csr | base64 | tr -d "\n"


##Kubernetes sign the request and approve it:

kubectl get csr

kubectl certificate approve dev

kubectl get csr/dev -o yaml

kubectl get csr dev -o jsonpath='{.status.certificate}'| base64 -d > dev.crt --> else decode the status.certificate and store it in dev.crt

##add new credentials to user in kube config

kubectl config set-credentials dev --client-key=dev.key --client-certificate=dev.crt --embed-certs=true

##Set context for user in kube config

kubectl config set-context dev --cluster=docker-desktop --user=dev


## switch context to user

kubectl config use-context dev


#Roles, cluster role and Service account

Role: SPecific to any namespace

ClusterRole": role for whole cluster

Roelebinding: 

Service Account: Service accounts are used by processes inside pods to interact with the Kubernetes API






kubectl config get-contexts

kubectl config use-context docker-desktop





LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1lqQ0NBVW9DQVFBd0hURU1NQW9HQTFVRUF3d0RaR1YyTVEwd0N3WURWUVFLREFScVlYWmhNSUlCSWpBTgpCZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUExMENXV1N3czMwVStDV2xUdyszc1lCKy96M0JNCnBDMEloZ0hJYmsxUG1iOEdYZmVqMklBb20wdnJzQlZHTGVGYmdSY0hvVWlNdXIwT1gvcllPckZaSnRqNThrdXEKMlphRk5Xc2hEelpIYXhQOS8waW1zUnZyRFFES3JKckg0T1JYdmhtWTJqRHZOZXV6aXUrVHJndWJlMEt5bG5tbgpSV3hXdDFra2g0dFZiNTVxYllMbGxZbVduM3J3aW1Nbi9GK2VZWFJhUUVtemhIeTVnbTkwN2FiWFdMRWdEVFAvCnRLaGM1Qmh0Sk9vYVRLRk1YalVWWnhuMlQzckdrSlNpaTdodFkvVllaeGg2ejFYSXJRRHJwa2E4cTJzMFlvbmsKT1BRaUVoczAwYzhmRkFZUlU3MFVCU0xkam5kM0tOWXFuWEk2ZXplbk5ZdmFWeS9XZ3A4NytJQkpOd0lEQVFBQgpvQUF3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUpFRkpzMms3dGFFdUxiM2l5dW54M1B0dk0xRERabFladEIrCk1rZS95V09NOE5idVI0b3Q2M2hBWTFkRTBNQ0dxUkdJMitPWHRlemVIVDN4NnE5SzU0VTVaS3MxbXRzSENUb0UKeElkTzVEb0RTaUFDSForaUl6RDd5ZjltTlB6Y3Uxa1k3eDZUeUl4N211VXVPd0w5TUhwU2ZDQ0dNV1lrWmFJdgozNzVpZFZEZXJpY3M3K2JlYjFDQ0xJZGtzdlNqb2JITnF5bVFRT2tqMVFMU3hLWHIzMUFnM2ZlWmg1d3NRbmJuCjg4QVV5SDJBeUhQbHBXNjdSYWVlWVJ0eWwrSzZDYzQ3MWF1TnRLWXNEcFE1MFZ5YnVVTnlaNjkvek5KbnhhenQKYzArdGlyUW9hbVNueFNkQlFiUTFOT1lyZ2pjQXdpYWpmaGR1bndTNjA4UzAyWDZmQk9VPQotLS0tLUVORCBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0K