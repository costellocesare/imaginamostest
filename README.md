# imaginamos Prueba técnica para DevOps

1. Creación de un repositorio con CI/CD
   
    ● Crea un repositorio en GitHub con un código básico (puede ser un servicio web
minimalista en cualquier lenguaje, por ejemplo, Node.js, Python, Go o cualquier
otro de tu preferencia).

● Configura un pipeline de CI/CD usando GitHub Actions. El pipeline debe incluir:

  1. Build: Compilar el código.
  2. Test: Ejecutar pruebas unitarias y enviar los resultados a Sonarqube.
  3. Deploy: Desplegar la aplicación en un clúster EKS en AWS.
  
  
  Requisitos:
    Estas Credenciales tiene duración de una semana
            ● Aws Access Key ################## <br>
            ● Aws Secret Access Key  ################
      ● Cluster Name ##################
      ● Sonar URL #################
      ● Sonar Token #######################
      
Si poseen un error en la comunicación o conexión deben describir el error y
proponer cuál es la configuración faltante para llevar a cabo el proceso

Desarrollo:

Se creo el repositorio con CI/CD configurando el pipeline de github actions ci-cd.yml, las credenciales de AWS se registraron como secretos en el repositorio, tuve problemas para deplegar el EKS en AWS porque no tengo acceso al aws, para poderlo desplegar con aws solo habria que agregar mi usuario IAM a kubernetes para poder tener los permisos necesarios para conectarme al cluster, y luego tener los permisos dentro del cluster para poder realizar cambios, para sortearlo lo que hice fue un contenedor en docker hub y lo configure para comprobar que el pipeline funcionaba correctamente. ahora para pasarlo a que funcione con AWS una vez tenga los accesos cambiamos el pipeline al cluster de AWS y listo. (quedo comentado en el .yml)


2. Generación de infraestructura con Terraform
   
  Crea un archivo de Terraform que cumpla con los siguientes requisitos:
  
      1. Infraestructura base:
        ○ Una red VPC configurada con subnets públicas y privadas.
        ○ Reglas de seguridad (Security Groups) necesarias.
        ○ Un Internet Gateway y NAT Gateway.
        
      2. Recursos principales:
        ○ Un clúster EKS con nodos configurados.
        ○ Una base de datos RDS (PostgreSQL o MySQL).
        ○ Opcional: DocumentDB o buckets S3. La elección debe depender de la
          variable project_type ("database" o "storage").

      3. Configuraciones adicionales:

        ○ Configurar IAM Roles y Policies necesarias para los servicios.
        ○ Proveer opciones escalables para los nodos del clúster.
        
Entrega:
  ● Proporciona los archivos .tf necesarios para levantar esta infraestructura en
AWS.
  ● Asegúrate de incluir variables reutilizables para facilitar la personalización.


  Desarrollo: 

en el repositorio https://github.com/costellocesare/imaginamostest/tree/main/terraform se generaron los .tf como se solicitaron estructurados en los modulos EKS, RDS, S3 y VPC, se ejecuto el terraform init, terraform plan y terraform apply, siendo este ultimo el unico que fallo por los motivos de no llegar al aws por mis permisos.

3. Monitoreo centralizado de microservicios
   
  Diseña un proceso para monitorear los logs de múltiples microservicios distribuidos en varios clústeres EKS. Describe:
  
    1. Las herramientas seleccionadas y su configuración:
      ○ Logs: Propón una solución centralizada para recolectar y visualizar logs, por ejemplo, Loki con Grafana o Elasticsearch con Kibana.
      ○ Costos y eficiencia: Argumenta por qué estas herramientas son eficientes en términos de costo y escalabilidad.

    2. Proceso:
      ○ Cómo configuraste la recolección de logs desde los microservicios.
      ○ Cómo los desarrolladores pueden consultar fallos específicos en tiempo real.

    3. Opcional: Proponer métricas clave para medir la salud de los microservicios (uso de recursos, tiempos de respuesta, errores).

    Entrega:
      ● Documentación del proceso con diagramas si es necesario.
      ● Configuración y ejemplos de código para implementar esta solución.

      Desarrollo: 
Se entrega en el documento https://github.com/costellocesare/imaginamostest/blob/main/Monitoreo/Monitoreo%20centralizado%20de%20microservicios.pdf


Prueba finalizada.
