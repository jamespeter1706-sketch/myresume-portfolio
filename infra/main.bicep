- name: Deploy Infrastructure via Bicep
      id: bicep_deploy
      uses: azure/arm-deploy@v1
      with:
        subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        resourceGroupName: ${{ secrets.AZURE_RG }}
        template: ./infra/main.bicep
        
    - name: Activate Static Hosting and Upload Site Files
      uses: azure/CLI@v2
      with:
        azcliversion: 2.86.0
        inlineScript: |
          # Dynamically grab the name from the Bicep output step
          STORAGE_NAME="${{ steps.bicep_deploy.outputs.storageAccountName }}"
          
          echo "Targeting storage account: $STORAGE_NAME"
          
          # Enable static website hosting
          az storage blob service-properties update --account-name $STORAGE_NAME --static-website --index-document index.html
          
          # Upload your frontend site files
          az storage blob upload-batch --account-name $STORAGE_NAME -s ./site -d '$web'